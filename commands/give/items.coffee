_ = require 'underscore'
Bluebird = require 'bluebird'
db = require '../../db'
data = require '../../data'

db.register_index db.characters,
  _id: 1
  'items.item': 1

# Converts object of style
#   {pelt: 1, tooth: 3}
# To:
#   [{item: pelt, count: 1}, {item: tooth, count: 3}]
to_item_array = (object) ->
  keys = _.keys(object)
  if _.contains(keys, "item") && _.contains(keys, "count")
    [object]
  else
    items_to_give = []
    items_to_give.push item: key, count: value for key, value of object
    items_to_give

to_data_item = (item) ->
  return item if item?.id?.length
  return data.items[item]

give_item = (character, tile, item, count) ->
  throw 'Invalid Item' unless item?.id?.length
  target = character
  target ?= tile

  has_some = _.some target.items ? [], (i) ->
    i.item is item.id
  if not target.items?
    query =
      _id: target._id
    update =
      $set:
        items: [
          item: item.id
          count: count
        ]
        weight: item.weight * count
  else if has_some
    query =
      _id: target._id
      'items.item': item.id
    update =
      $inc:
        'items.$.count': count
        weight: item.weight * count
  else
    query =
      _id: target._id
    update =
      $inc:
        weight: item.weight * count
      $push:
        items:
          item: item.id
          count: count

  if target.email? or target.creature?
    db.characters().updateOne query, update
  else
    db.tiles().updateOne query, update

module.exports = (character, tile, msg) ->
  items = [].concat(msg)
  Bluebird.resolve(items)
    .map to_item_array
    .then _.flatten
    .each (item) ->
      give_item character, tile, to_data_item(item.item), item.count
