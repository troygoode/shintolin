db = require '../db'

db.register_index db.tiles,
  x: 1
  y: 1
  z: 1

module.exports = (coords, cb) ->
  query =
    x:
      $gt: coords.x - 3
      $lt: coords.x + 3
    y:
      $gt: coords.y - 3
      $lt: coords.y + 3
    z: coords.z
  db.tiles.find(query).toArray cb
