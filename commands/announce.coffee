_ = require 'underscore'
async = require 'async'
db = require '../db'
queries = require '../queries'

module.exports = (text = "", cb) ->
  now = new Date()
  queries.all_players (err, characters) ->
    return cb(err) if err?
    async.forEach characters, (actor, cb) ->
      m =
        type: 'announcement'
        text: text
        sent: now
        recipient_id: actor._id
      db.chat_messages.insert m, cb
    , cb
