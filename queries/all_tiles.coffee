db = require '../db'

db.register_index db.tiles,
  x: 1
  y: 1
  z: 1

module.exports = (z, cb) ->
  query =
    z: z
  db.tiles.find(query).sort(y: 1, x: 1).toArray cb
