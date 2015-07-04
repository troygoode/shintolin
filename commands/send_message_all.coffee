_ = require 'underscore'
async = require 'async'
db = require '../db'

module.exports = (type, sender, recipients, blacklist = [], message = {}, cb) ->
  now = new Date()
  async.forEach recipients, (recipient, cb) ->
    blacklisted = _.some blacklist, (a) ->
      a?._id.toString() is recipient?._id.toString()
    if blacklisted or recipient.creature?
      cb()
    else
      m = _.extend
        type: type
        sender_name: sender?.name
        sender_id: sender?._id
        sender_slug: sender?.slug
        sent: now
      , message
      m.recipient_id = recipient._id if recipient?
      db.chat_messages.insert m, cb
  , cb
