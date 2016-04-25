_ = require 'underscore'
Bluebird = require 'bluebird'
{buildings, items} = require '../'
craft = Bluebird.promisify(require '../../commands/craft')
send_message = Bluebird.promisify(require '../../commands/send_message')
send_message_nearby = Bluebird.promisify(require '../../commands/send_message_nearby')
can_take = require '../../queries/can_take'

describe_recipe = (character, tile, building) ->
  recipe = building.repair character, tile
  can_take_response = can_take character, tile, recipe.takes
  return false if can_take_response.craftable is false and can_take_response.hard is true

  label = ""

  if recipe.takes?.items?
    label += "#{recipe.takes.ap ? 0} AP"
    for item, count of recipe.takes.items
      label += ", #{count}x #{items[item].name}"
  else if recipe.takes?.ap
    label += "#{recipe.takes.ap} AP"
  label

module.exports = (character, tile) ->
  return false unless tile?.building?
  building = buildings[tile.building]
  return false unless building?.repair?
  io = building.repair character, tile
  return false unless io?
  ap = io.takes?.ap ? 1
  description = describe_recipe character, tile, building
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
        craft character, tile, building, 'repair'

      .then ([io, broken_items]) ->
          throw 'You cannot repair this building right now.' unless io?
          Bluebird.all [
            send_message 'repair', character, character,
              building: building.id
              gives: io.gives
              takes: io.takes
              broken: broken_items
            send_message_nearby 'repair_nearby', character, [character],
              building: building.id
              gives: io.gives
              takes: io.takes
              broken: broken_items
          ]
