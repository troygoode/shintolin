_ = require 'underscore'
async = require 'async'
db = require '../db'
queries = require '../queries'

module.exports = (type, sender, blacklist = [], message = {}, cb) ->
  now = new Date()
  queries.get_tile_by_coords sender, (err, tile) ->
    return cb(err) if err?
    async.forEach tile.people, (actor, cb) ->
      blacklisted = _.some blacklist, (a) ->
        a._id.toString() is actor._id.toString()
      if blacklisted
        cb()
      else
        m = _.extend
          type: type
          sender_name: sender.name
          sender_id: sender._id
          sender_slug: sender.slug
          sent: now
          recipient_id: actor._id
        , message
        db.chat_messages.insert m, cb
    , (err) ->
      cb err
