BPromise = require 'bluebird'
config = require '../../config'
craft = BPromise.promisify(require '../../commands/craft')
create_building = BPromise.promisify(require '../../commands/create_building')
send_message = BPromise.promisify(require '../../commands/send_message')
send_message_nearby = BPromise.promisify(require '../../commands/send_message_nearby')
characters = require("../../db").characters
data = require '../'
update_characters = BPromise.promisify(characters.update, characters)
BASE_RECOVERY = config.ap_per_hour

module.exports = (character, tile) ->
  buildings = {}
  for key, building of data.buildings
    recipe = building.build character, tile
    if not recipe.takes?.developer or character.developer
      if recipe.takes?.items?
        label = "#{building.name} (#{recipe.takes.ap ? 0}AP"
        for item, count of recipe.takes.items
          label += ", #{count}x #{data.items[item].name}"
        label += ")"
      else if recipe.takes?.ap
        label = "#{building.name} (#{recipe.takes.ap}AP)"
      else
        label = building.name
      buildings[key] =
        label: label
        object: building

  category: 'location'
  buildings: buildings

  execute: (body, req, res, next) ->
    BPromise.resolve()
      .then ->

        throw 'You cannot build a building inside a building.' if tile.z isnt 0 #Xyzzy shenanigans!

        building = buildings[body.building].object
        throw 'Invalid Building'  unless building?
        throw 'There is already a building here.' if tile.building? and not building.upgrade

        terrain = data.terrains[tile.terrain]
        throw 'Nothing can be built here.' unless terrain.buildable?
        throw 'You cannot build that here.' unless terrain.buildable.indexOf(building.size) isnt -1

        # special handling for totems and other devices
        return building.build_handler(req, res, next) if building.build_handler?

        if tile.settlement_id? and (
          not character.settlement_id? or
          character.settlement_id.toString() isnt tile.settlement_id.toString() or
          character.settlement_provisional
        )
          throw 'You must be a non-provisional member of this settlement to build here.'

        BPromise.resolve()
          .then ->
            craft character, tile, building, 'build'
          .tap ->
            create_building tile, building
          .tap ->
            return unless building.recovery?
            recovery = building.recovery character, tile
            query =
              creature:
                $exists: false
              x: tile.x
              y: tile.y
              z: tile.z
            update =
              $set:
                recovery: (BASE_RECOVERY + recovery)
            update_characters query, update, null, true
          .tap (io, broken_items) ->
              send_message 'built', character, character,
                building: building.id
                gives: io.gives
                takes: io.takes
                broken: broken_items
          .tap (io, broken_items) ->
              send_message_nearby 'built_nearby', character, [character],
                building: building.id
                gives: io.gives
                takes: io.takes
                broken: broken_items
