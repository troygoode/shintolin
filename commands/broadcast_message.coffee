_ = require 'underscore'
db = require '../db'

module.exports = (type, sender, blacklist, message, cb) ->
  m = _.extend
    type: type
    sender_name: sender.name
    sender_id: sender._id
    sent: new Date()
  , message
  m.recipient_id = recipient._id if recipient?
  db.chat_messages.insert m, cb
