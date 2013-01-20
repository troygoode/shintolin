_ = require 'underscore'
db = require '../db'

db.register_index db.characters,
  _id: 1
  'items.item': 1

module.exports = (character, item, count, cb) ->
  has_some = _.some character.items, (i) ->
    i.item is item.id
  if has_some
    query =
      _id: character._id
      'items.item': item.id
    update =
      $inc:
        'items.$.count': count
        weight: item.weight * count
    db.characters.update query, update, false, true, cb
  else
    query =
      _id: character._id
    update =
      $inc:
        weight: item.weight * count
      $push:
        items:
          item: item.id
          count: count
    db.characters.update query, update, false, true, cb
