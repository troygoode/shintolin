db = require '../db'

module.exports = (tile, delta, cb) ->
  query =
    _id: tile._id
  update =
    $inc:
      overuse: delta
  db.tiles().updateOne query, update, cb
