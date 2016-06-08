_ = require 'underscore'
Bluebird = require 'bluebird'
{items, buildings} = require '../'
craft = require '../../commands/craft'
send_message = Bluebird.promisify(require('../../commands').send_message)
send_message_nearby = Bluebird.promisify(require('../../commands').send_message_nearby)
MAX_WEIGHT = 70

by_name = (ic) ->
  item = items[ic.item]
  item.name

module.exports = (character, tile) ->
  takeables = {}
  for ic in _.sortBy(tile.items, by_name)
    item = items[ic.item]
    if ic.count > 1
      takeables[item.id] = "#{item.plural} (#{ic.count}x total)"
    else
      takeables[item.id] = "#{item.name} (#{ic.count}x total)"
  return false if _.isEmpty(takeables)

  category: 'building'
  max_count: _.max(_.pluck(tile.items, 'count'))
  takeables: takeables

  execute: (body) ->
    item = items[body.item]
    building = buildings[tile.building]
    quantity = parseInt(body.quantity ? 1)
    is_guarded = tile.settlement_id? and tile.people.some (p) ->
      p.hp > 0 and p.settlement_id? and p.settlement_id.toString() is tile.settlement_id.toString()

    Bluebird.resolve()
      .then ->
        throw 'Invalid Item' unless item?

        recipe =
          gives:
            items: {}
          takes:
            ap: quantity
            tile_items: {}

        recipe.gives.items[item.id] = quantity
        recipe.takes.tile_items[item.id] = quantity

        if is_guarded and building.tags? and _.contains(building.tags ? [], 'guard_take')
          recipe.takes.membership = true

        craft character, tile, recipe

      .then ->
        send_message 'take', character, character,
          item: item.id
          quantity: quantity
          building: tile.building

      .then ->
        send_message_nearby 'take_nearby', character, [character],
          item: item.id
          quantity: quantity
          building: tile.building
