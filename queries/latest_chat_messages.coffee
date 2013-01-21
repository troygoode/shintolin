db = require '../db'

db.register_index db.chat_messages,
  sent: -1
  recipient_id: 1

module.exports = (character, skip, limit, cb) ->
  query =
    $or: [
      {recipient_id: character._id}
      {recipient_id: null}
    ]
  db.chat_messages.find(query).sort({ sent: -1 }).skip(skip).limit(limit).toArray cb
