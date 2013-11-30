async = require 'async'
db = require '../db'
queries = require '../queries'
send_message_settlement = require './send_message_settlement'

db.register_index db.settlements,
  _id: 1
  'members._id': 1

module.exports = (character, cb) ->
  queries.get_settlement character.settlement_id.toString(), (err, settlement) ->
    return cb(err) if err?
    async.series [
      (cb) ->
        # update character records
        query =
          _id: character._id
        update =
          $unset:
            settlement_provisional: true
        db.characters.update query, update, cb
      (cb) ->
        # update settlement records
        query =
          _id: settlement._id
          'members._id': character._id
        update =
          $unset:
            'members.$.provisional': true
        db.settlements.update query, update, cb
      (cb) ->
        # notify
        message =
          settlement_id: settlement._id
          settlement_name: settlement.name
          settlement_slug: settlement.slug
        send_message_settlement 'nonprovisional', character, settlement, [], message, cb
    ], cb
