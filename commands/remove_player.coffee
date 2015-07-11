async = require 'async'
db = require '../db'

db.register_index db.tiles,
  'people._id': 1
db.register_index db.settlements,
  'members._id': 1

module.exports = (character, cb) ->
  async.parallel [
    (cb) ->
      db.characters.remove _id: character._id, cb
    (cb) ->
      query =
        'people._id': character._id
      update =
        $pull:
          people:
            _id: character._id
      db.tiles.update query, update, false, true, cb
    (cb) ->
      query =
        'members._id': character._id
      update =
        $pull:
          members:
            _id: character._id
      db.settlements.update query, update, false, true, cb
    (cb) ->
      query =
        sender_id: character._id
      db.chat_messages.remove query, cb
    (cb) ->
      query =
        recipient_id: character._id
      db.chat_messages.remove query, cb
  ], cb
