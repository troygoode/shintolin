db = require '../db'

module.exports = (tile, cb) ->
  query =
    _id: tile._id
  if tile.searches and tile.searches > 0
    update =
      $inc:
        searches: 1
  else
    update =
      $set:
        searches: 1
  db.tiles().updateOne query, update, cb
