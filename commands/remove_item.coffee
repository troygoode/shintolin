_ = require 'underscore'
db = require '../db'

db.register_index db.characters,
  _id: 1
  'items.item': 1
db.register_index db.tiles,
  _id: 1
  'items.item': 1

module.exports = (target, item, count, cb) ->
  current_count = _.max (target.items ? []).filter((i) -> i.item is item.id).map((i) -> i.count)
  count = parseInt count
  return cb("Not carrying that many #{item.plural}.") if count > current_count

  if current_count is 1 or current_count is count
    query =
      _id: target._id
      'items.item': item.id
    update =
      $pull:
        items:
          item: item.id
      $inc:
        weight: 0 - (item.weight * count)
  else
    query =
      _id: target._id
      'items.item': item.id
    update =
      $inc:
        'items.$.count': 0 - count
        weight: 0 - (item.weight * count)

  if target.terrain? or target.building?
    db.tiles().updateOne query, update, cb
  else if target.email? or target.creature?
    db.characters().updateOne query, update, cb
  else
    cb 'Invalid target for remove_item'
