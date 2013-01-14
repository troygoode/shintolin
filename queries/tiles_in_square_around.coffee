db = require '../db'

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
