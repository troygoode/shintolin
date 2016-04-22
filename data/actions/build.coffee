_ = require 'underscore'
BPromise = require 'bluebird'
config = require '../../config'
craft = BPromise.promisify(require '../../commands/craft')
create_building = BPromise.promisify(require '../../commands/create_building')
send_message = BPromise.promisify(require '../../commands/send_message')
send_message_nearby = BPromise.promisify(require '../../commands/send_message_nearby')
data = require '../'
can_take = require '../../queries/can_take'
BASE_RECOVERY = config.ap_per_hour

module.exports = (character, tile) ->
  characters = require('../../db').characters()
  update_characters = BPromise.promisify(characters.update, characters)

  return false unless tile?
  current_building = if tile.building? then data.buildings[tile.building]
  return false unless (tile.z is 0 and not current_building?) or (tile.z is 0 and current_building? and current_building.upgradeable_to?)

  button_text = 'Build'
  buildings = {}

  add_recipe = (key, building) ->
    recipe = building.build character, tile
    return if recipe?.takes?.developer
    can_take_response = can_take character, tile, recipe.takes
    return if can_take_response.craftable is false and can_take_response.hard is true

    label = ""
    if can_take_response.craftable
      label += "✅ "
    else
      label += "❌ "

    label += building.name

    if recipe.takes?.items?
      label += " (#{recipe.takes.ap ? 0} AP"
      for item, count of recipe.takes.items
        label += ", #{count}x #{data.items[item].name}"
      label += ")"
    else if recipe.takes?.ap
      label += " (#{recipe.takes.ap} AP)"
    buildings[key] =
      label: label
      object: building

  if current_building?.upgradeable_to?
    button_text = 'Upgrade'
    for key in (if _.isArray(current_building.upgradeable_to) then current_building.upgradeable_to else [current_building.upgradeable_to])
      add_recipe key, data.buildings[key]
  else
    for key, building of data.buildings
      unless building.upgrade
        add_recipe key, building

  return false if _.isEmpty(buildings)

  category: 'building'
  buildings: buildings
  text:
    submit: button_text

  execute: (body, req, res, next) ->
    promise = BPromise.resolve()
      .then ->

        throw 'You cannot build a building inside a building.' if tile.z isnt 0 #Xyzzy shenanigans!

        building = buildings[body.building].object
        throw 'Invalid Building'  unless building?
        throw 'There is already a building here.' if tile.building? and not building.upgrade

        terrain = data.terrains[tile.terrain]
        throw 'Nothing can be built here.' unless terrain.buildable?
        throw 'You cannot build that here.' unless terrain.buildable.indexOf(building.size) isnt -1

        # special handling for totems and other devices
        if building.build_handler?
          building.build_handler(req, res, next)
          return promise.cancel()

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
      .catch BPromise.CancellationError, (err) ->
        console.log err
        return
    return promise
