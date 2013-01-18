db = require '../db'

module.exports = (tile, terrain, cb) ->
  query =
    _id: tile._id
  update =
    $set:
      terrain: terrain
  db.tiles.update query, update, cb
