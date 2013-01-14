db = require '../db'

module.exports = (character, text, cb) ->
  message =
    sender_name: character.name
    sender_id: character._id
    sent: new Date()
    text: text
    type: 'social'
  db.chat_messages.insert message, cb
