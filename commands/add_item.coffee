_ = require 'underscore'
db = require '../db'
data = require '../data'

db.register_index db.tiles,
  _id: 1
  'items.item': 1
db.register_index db.characters,
  _id: 1
  'items.item': 1

module.exports = (target, item, count, cb) ->
  return cb('Invalid Item') unless item?.id?.length

  has_some = _.some target.items ? [], (i) ->
    i.item is item.id
  if has_some
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

  if target.building?
    db.tiles.update query, update, cb
  else
    db.characters.update query, update, cb
