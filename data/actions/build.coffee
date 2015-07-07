BPromise = require 'bluebird'
craft = BPromise.promisify(require '../../commands/craft')
create_building = BPromise.promisify(require '../../commands/create_building')
send_message = BPromise.promisify(require '../../commands/send_message')
send_message_nearby = BPromise.promisify(require '../../commands/send_message_nearby')
data = require '../'

module.exports = (character, tile) ->

  category: 'location'

  execute: (body, req, res, next) ->
    BPromise.resolve()
      .then ->

        throw 'You cannot build a building inside a building.' if tile.z isnt 0 #Xyzzy shenanigans!

        building = data.buildings[body.building]
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
