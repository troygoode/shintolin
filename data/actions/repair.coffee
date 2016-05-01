_ = require 'underscore'
Bluebird = require 'bluebird'
{buildings, items} = require '../'
craft = require '../../commands/craft'
send_message = Bluebird.promisify(require '../../commands/send_message')
send_message_nearby = Bluebird.promisify(require '../../commands/send_message_nearby')
can_take = require '../../queries/can_take'

describe_recipe = (character, tile, recipe) ->
  Bluebird.resolve()
    .then ->
      can_take(character, tile, recipe.takes)
        .catch (err) ->
          return {craftable: false, hard: true} if err?.hard
          craftable: false

    .then (can_take_response) ->
      return false if can_take_response?.hard is true

      label = ""
      if recipe.takes?.items?
        label += "#{recipe.takes.ap ? 0} AP"
        for item, count of recipe.takes.items
          label += ", #{count}x #{items[item].name}"
      else if recipe.takes?.ap
        label += "#{recipe.takes.ap} AP"
      label

module.exports = (character, tile) ->
  building = null
  ap = null
  Bluebird.resolve()
    .then ->
      return false unless tile?.building?
      building = buildings[tile.building]
      return false unless building?.repair?
      recipe = building.repair character, tile
      return false unless recipe?
      ap = recipe.takes?.ap ? 1
      describe_recipe character, tile, recipe

    .then (description) ->
      return false if description is false

      category: 'building'
      ap: ap
      charge_ap: false # handled by recipe
      text:
        button: building.text?.repair?.button ? 'Repair'
        description: description

      execute: ->
        Bluebird.resolve()

          .then ->
            craft character, tile, building.repair.bind(building)

          .then ({recipe, broken_items}) ->
              throw 'You cannot repair this building right now.' unless recipe?
              Bluebird.all [
                send_message 'repair', character, character,
                  building: building.id
                  gives: recipe.gives
                  takes: recipe.takes
                  broken: broken_items
                send_message_nearby 'repair_nearby', character, [character],
                  building: building.id
                  gives: recipe.gives
                  takes: recipe.takes
                  broken: broken_items
              ]
