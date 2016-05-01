Bluebird = require 'bluebird'
_ = require 'underscore'

data = require '../../data'
remove_item = Bluebird.promisify(require '../remove_item')

module.exports.can = (character, tile, msg) ->
  items_to_take = []
  items_to_take.push item: key, count: value for key, value of msg
  for takeable in items_to_take
    item = data.items[takeable.item]
    item_in_inventory = _.find character.items, (i) ->
      i.item is item.id
    throw "You don't have enough #{item.plural} to do that." unless item_in_inventory?.count >= takeable.count

module.exports.take = (character, tile, msg) ->
  items_to_take = []
  items_to_take.push item: key, count: value for key, value of msg
  Bluebird.resolve(items_to_take)
    .each (item) ->
      remove_item character, data.items[item.item], item.count
