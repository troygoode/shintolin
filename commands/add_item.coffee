_ = require 'underscore'
db = require '../db'

module.exports = (character, item, count, cb) ->
  has_some = _.some character.items, (i) ->
    console.log "#{i.item} is #{item.id}"
    i.item is item.id
  console.log has_some
  if has_some
    console.log 1
    query =
      'items.item': item.id
    update =
      $inc:
        'items.$.count': count
        weight: item.weight * count
    db.characters.update query, update, false, true, cb
  else
    console.log 2
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
