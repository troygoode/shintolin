_ = require 'underscore'
Bluebird = require 'bluebird'
config = require '../../config'
craft = require '../../commands/craft'
create_building = Bluebird.promisify(require '../../commands/create_building')
send_message = Bluebird.promisify(require '../../commands/send_message')
send_message_nearby = Bluebird.promisify(require '../../commands/send_message_nearby')
data = require '../'
can_take = require '../../queries/can_take'
BASE_RECOVERY = config.ap_per_hour

module.exports = (character, tile) ->
  BUTTON_TEXT = 'Build'

  add_recipe = (key) ->
    building = data.buildings[key]
    recipe = building.build character, tile
    Bluebird.resolve()
      .then ->
        return {craftable: false, hard: true} if recipe?.takes?.developer
        can_take(character, tile, recipe.takes)
          .catch (err) ->
            return {craftable: false, hard: true} if err?.hard
            craftable: false
      .then (can_take_response) ->
        return false if can_take_response?.hard is true
        label = ""
        if can_take_response?.craftable is false
          label += "❌ "
        else
          label += "✅ "

        label += building.name

        if recipe.takes?.items?
          label += " (#{recipe.takes.ap ? 0} AP"
          for item, count of recipe.takes.items
            label += ", #{count}x #{data.items[item].name}"
          label += ")"
        else if recipe.takes?.ap
          label += " (#{recipe.takes.ap} AP)"

        [key, {
          label: label
          object: building
        }]

  Bluebird.resolve()
    .then ->
      return false unless tile?
      current_building = if tile.building? then data.buildings[tile.building]
      return false unless (tile.z is 0 and not current_building?) or (tile.z is 0 and current_building? and current_building.upgradeable_to?)

      keys = []
      if current_building?.upgradeable_to?
        BUTTON_TEXT = 'Upgrade'
        for key in (if _.isArray(current_building.upgradeable_to) then current_building.upgradeable_to else [current_building.upgradeable_to])
          keys.push key
      else
        for key, building of data.buildings
          unless building.upgrade
            keys.push key

      Bluebird.resolve(keys)
        .map (key) ->
          add_recipe key

        .then (recipes) ->
          _.object(recipes.filter((r) -> r? is true and r isnt false))

        .then (buildings) ->
          return false if _.isEmpty(buildings)

          category: 'building'
          buildings: buildings
          text:
            submit: BUTTON_TEXT

          execute: (body, req, res, next) ->
            characters = require('../../db').characters()
            promise = Bluebird.resolve()
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

                Bluebird.resolve()
                  .then ->
                    craft(character, tile, building.build.bind(building))
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
                    characters.updateMany query, update
                  .tap ({recipe, broken_items}) ->
                    send_message 'built', character, character,
                      building: building.id
                      gives: recipe.gives
                      takes: recipe.takes
                      broken: broken_items
                  .tap ({recipe, broken_items}) ->
                    send_message_nearby 'built_nearby', character, [character],
                      building: building.id
                      gives: recipe.gives
                      takes: recipe.takes
                      broken: broken_items
              .catch Bluebird.CancellationError, (err) ->
                console.log err
                return

            return promise
