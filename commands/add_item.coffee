_ = require 'underscore'
db = require '../db'

module.exports = (character, item, count, cb) ->
  has_some = _.some character.items, (i) ->
    i.item is item
  if has_some
    query =
      'items.item': item
    update =
      $inc:
        'items.$.count': count
  else
    query =
      _id: character._id
    update =
      $push:
        items:
          item: item
          count: count
  db.characters.update query, update, cb
