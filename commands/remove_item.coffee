_ = require 'underscore'
db = require '../db'

module.exports = (character, item, count, cb) ->
  current_count = _.max(character.items, (i) ->
    i.count).count
  count = parseInt count
  if count > current_count
    cb "Not carrying that many #{item.name}."
  else if current_count is 1 or current_count is count
    query =
      'items.item': item.id
    update =
      $pull:
        items:
          item: item.id
          count: current_count
      $inc:
        weight: 0 - (item.weight * count)
    db.characters.update query, update, cb
  else if current_count > 1
    query =
      'items.item': item.id
    update =
      $inc:
        'items.$.count': 0 - count
        weight: 0 - (item.weight * count)
    db.characters.update query, update, cb
  else
    cb()
