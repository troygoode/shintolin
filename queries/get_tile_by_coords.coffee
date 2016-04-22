db = require '../db'

db.register_index db.tiles,
  x: 1
  y: 1
  z: 1

module.exports = (coords, cb) ->
  query =
    x: coords.x
    y: coords.y
    z: coords.z ? 0
  db.tiles().findOne query, cb
