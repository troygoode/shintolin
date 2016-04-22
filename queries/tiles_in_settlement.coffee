db = require '../db'

db.register_index db.tiles,
  settlement_id: 1
  x: 1
  y: 1
  z: 1

module.exports = (settlement, cb) ->
  query =
    settlement_id: settlement._id
    z: 0
  db.tiles().find(query).sort(y: 1, x: 1).toArray cb
