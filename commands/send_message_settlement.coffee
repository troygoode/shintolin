Bluebird = require 'bluebird'
db = require '../db'
send_message_all = require './send_message_all'

module.exports = (type, sender, settlement, blacklist = [], message = {}, cb) ->
  Bluebird.resolve()
    .then ->
      if settlement?._id?
        settlement
      else
        db.settlements().findOne(_id: settlement)
    .then (s) ->
      message.settlement_id = s._id
      message.settlement_name = s.name
      message.settlement_slug = s.slug
      send_message_all type, sender, s.members, blacklist, message, cb
    .catch (err) ->
      cb err
