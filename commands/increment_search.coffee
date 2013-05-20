db = require '../db'

module.exports = (tile, cb) ->
  query =
    _id: tile._id
  update =
    $inc:
      searches: 1
  db.tiles.update query, update, cb
