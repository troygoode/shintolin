_ = require 'underscore'
db = require '../db'

module.exports = (character, message, cb) ->
  m = _.extend
    sender_name: character.name
    sender_id: character._id
    sent: new Date()
  , message
  db.chat_messages.insert m, cb
