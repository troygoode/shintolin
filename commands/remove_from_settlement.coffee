async = require 'async'
db = require '../db'

module.exports = (character, cb) ->
  return cb() unless character.settlement_id?
  async.series [
    (cb) ->
      query =
        _id: character._id
      update =
        $unset:
          settlement_id: true
          settlement_slug: true
          settlement_name: true
          settlement_provisional: true
          settlement_joined: true
      db.characters().updateOne query, update, cb
    (cb) ->
      # update tile record
      query =
        'people._id': character._id
      update =
        $unset:
          'people.$.settlement_id': true
      db.tiles().updateOne query, update, cb
    (cb) ->
      # update settlement records
      query =
        _id: character.settlement_id
      update =
        $inc:
          population: -1
        $pull:
          members:
            _id: character._id
      db.settlements().updateOne query, update, cb
  ], cb
