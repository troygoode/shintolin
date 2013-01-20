db = require '../db'

db.register_index db.tiles,
  x: 1
  y: 1
  z: 1

module.exports = (coords, radius, cb) ->
  query =
    x:
      $gte: coords.x - radius
      $lte: coords.x + radius
    y:
      $gte: coords.y - radius
      $lte: coords.y + radius
    z: coords.z
  db.tiles.find(query).toArray cb
