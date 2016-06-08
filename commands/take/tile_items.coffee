Bluebird = require 'bluebird'
_ = require 'underscore'

data = require '../../data'
remove_item = Bluebird.promisify(require '../remove_item')

module.exports.can = (character, tile, msg) ->
  ref = 'The area'
  if tile.building?
    ref = "The #{data.buildings[tile.building].name}"

  items_to_take = []
  items_to_take.push item: key, count: value for key, value of msg
  for takeable in items_to_take
    item = data.items[takeable.item]
    item_in_inventory = _.find tile.items, (i) ->
      i.item is item.id
    throw "#{ref} doesn't have enough #{item.plural} to do that." unless item_in_inventory?.count >= takeable.count

module.exports.take = (character, tile, msg) ->
  items_to_take = []
  items_to_take.push item: key, count: value for key, value of msg
  Bluebird.resolve(items_to_take)
    .each (item) ->
      remove_item tile, data.items[item.item], item.count
