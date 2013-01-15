db = require '../db'

db.register_index db.tiles,
  x: 1
  y: 1
  z: 1

module.exports = (coords, radius, cb) ->
  query =
    x:
      $gt: coords.x - radius
      $lt: coords.x + radius
    y:
      $gt: coords.y - radius
      $lt: coords.y + radius
    z: coords.z
  db.tiles.find(query).toArray cb
