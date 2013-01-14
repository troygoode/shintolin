db = require '../db'

db.register_index db.chat_messages,
  sent: -1

module.exports = (character, cb) ->
  query = {}
  db.chat_messages.find(query).sort({ sent: -1 }).toArray cb
