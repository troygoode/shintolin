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
      db.characters.update query, update, cb
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
      db.settlements.update query, update, cb
  ], cb
