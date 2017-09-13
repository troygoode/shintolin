db = require '../db'

module.exports = (settlement_id, cb) ->
  query =
    settlement_id: settlement_id
    hp:
      $lte: 0

  db.characters().find(query).sort(name: 1).toArray cb
