async = require 'async'
send_message = require '../send_message'
send_message_nearby = require '../send_message_nearby'

module.exports = (user, target, item, tile, cb) ->
  for_self = target._id.toString() is user._id.toString()

  msg = {}
  unless for_self
    msg.target_id = target._id
    msg.target_name = target.name
    msg.target_slug = target.slug

  async.parallel [
    (cb) ->
      send_message 'ocarina', user, user, msg, cb
    (cb) ->
      send_message_nearby 'ocarina_nearby', user, [user], msg, cb
  ], cb
