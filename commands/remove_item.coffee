_ = require 'underscore'
db = require '../db'

db.register_index db.characters,
  _id: 1
  'items.item': 1

module.exports = (character, item, count, cb) ->
  current_count = _.max character.items.filter((i) -> i.item is item.id).map((i) -> i.count)
  count = parseInt count
  if count > current_count
    cb "Not carrying that many #{item.name}."
  else if current_count is 1 or current_count is count
    query =
      _id: character._id
      'items.item': item.id
    update =
      $pull:
        items:
          item: item.id
      $inc:
        weight: 0 - (item.weight * count)
    db.characters.update query, update, false, true, cb
  else if current_count > 1
    query =
      _id: character._id
      'items.item': item.id
    update =
      $inc:
        'items.$.count': 0 - count
        weight: 0 - (item.weight * count)
    db.characters.update query, update, false, true, cb
  else
    cb()
