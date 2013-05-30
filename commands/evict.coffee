async = require 'async'
db = require '../db'
queries = require '../queries'
send_message = require './send_message'
send_message_settlement = require './send_message_settlement'

module.exports = (character, cb) ->
  queries.get_settlement character.settlement_id, (err, settlement) ->
    return cb(err) if err?
    queries.get_character settlement.leader._id, (err, leader) ->
      return cb(err) if err?
      async.series [
        (cb) ->
          # update character records
          query =
            _id: character._id
          update =
            $unset:
              settlement_id: true
              settlement_slug: true
              settlement_name: true
              settlement_provisional: true
          db.characters.update query, update, cb
        (cb) ->
          # update settlement records
          query =
            _id: settlement._id
          update =
            $inc:
              population: -1
            $pull:
              members:
                _id: character._id
          db.settlements.update query, update, cb
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
