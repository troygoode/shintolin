_ = require 'underscore'
Bluebird = require 'bluebird'
{items, buildings} = require '../'
craft = Bluebird.promisify(require('../../commands').craft)
remove_item = Bluebird.promisify(require('../../commands').remove_item)
give_items = Bluebird.promisify(require('../../commands').give.items)
charge_ap = Bluebird.promisify(require('../../commands').charge_ap)
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

    Bluebird.resolve()
      .then ->
        throw 'Invalid Item' unless item?

        inventory_item = _.find tile.items, (i) ->
          i.item is item.id
        throw "The #{building.name} doesn\'t have #{quantity} #{item.name} to give away." unless inventory_item.count >= quantity

        weight = quantity * (item.weight ? 0)
        throw "Taking that would overburden you." if (character.weight + weight) > MAX_WEIGHT

      .then ->
        remove_item tile, item, quantity

      .then ->
        give_items character, null, {item: item, count: quantity}

      .then ->
        charge_ap character, quantity

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
