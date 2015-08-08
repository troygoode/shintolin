_ = require 'underscore'
Bluebird = require 'bluebird'
{items} = require '../'
remove_item = Bluebird.promisify(require('../../commands').remove_item)
give_items = Bluebird.promisify(require('../../commands').give.items)
charge_ap = Bluebird.promisify(require('../../commands').charge_ap)
send_message = Bluebird.promisify(require('../../commands').send_message)
send_message_nearby = Bluebird.promisify(require('../../commands').send_message_nearby)

by_name = (ic) ->
  item = items[ic.item]
  item.name

module.exports = (character, tile) ->
  giveables = {}
  for ic in _.sortBy(character.items, by_name)
    item = items[ic.item]
    unless item.nodrop or item.intrinsic
      if ic.count > 1
        giveables[item.id] = "#{item.plural} (#{ic.count}x total)"
      else
        giveables[item.id] = "#{item.name} (#{ic.count}x total)"
  return false if _.isEmpty(giveables)

  category: 'location'
  max_count: _.max(_.pluck(character.items, 'count'))
  giveables: giveables

  execute: (body) ->
    item = items[body.item]
    quantity = parseInt(body.quantity ? 1)

    Bluebird.resolve()
      .then ->
        throw 'Invalid Item' unless item?
        throw 'Invalid Item' if item.nodrop or item.intrinsic
        inventory_item = _.find character.items, (i) ->
          i.item is item.id
        throw "You don\'t have #{quantity} #{item.name} to give away." unless inventory_item.count >= quantity

      .then ->
        remove_item character, item, quantity

      .then ->
        give_items null, tile, {item: item, count: quantity}

      .then ->
        charge_ap character, quantity

      .then ->
        send_message 'give', character, character,
          item: item.id
          quantity: quantity
          building: tile.building

      .then ->
        send_message_nearby 'give_nearby', character, character,
          item: item.id
          quantity: quantity
          building: tile.building
