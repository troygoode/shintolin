Bluebird = require 'bluebird'
db = require '../../db'

module.exports = (character, tile, msg) ->
  throw 'No settlement to grant favor to!' unless tile.settlement_id?
  QUERY = _id: tile.settlement_id
  Bluebird.resolve()
    .then ->
      db.settlements().findOne(QUERY)
    .then (settlement) ->
      UPDATE =
        $inc:
          favor: msg
      db.settlements().updateOne(QUERY, UPDATE)
