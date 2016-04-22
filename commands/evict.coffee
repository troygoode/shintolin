async = require 'async'
queries = require '../queries'
remove_from_settlement = require './remove_from_settlement'
send_message = require './send_message'
send_message_settlement = require './send_message_settlement'

module.exports = (character, cb) ->
  queries.get_settlement character.settlement_id, (err, settlement) ->
    return cb(err) if err?
    queries.get_character settlement.leader._id, (err, leader) ->
      return cb(err) if err?
      async.series [
        (cb) ->
          remove_from_settlement character, cb
        (cb) ->
          # notify
          message =
            target_id: character._id
            target_name: character.name
            target_slug: character.slug
            settlement_id: settlement._id
            settlement_name: settlement.name
            settlement_slug: settlement.slug
          send_message 'evicted', leader, character, message, cb
        (cb) ->
          # notify settlement
          message =
            target_id: character._id
            target_name: character.name
            target_slug: character.slug
            settlement_id: settlement._id
            settlement_name: settlement.name
            settlement_slug: settlement.slug
          send_message_settlement 'evicted_settlement', leader, settlement, [character], message, cb
      ], cb
