db = require '../db'

module.exports = (character, tile, message, cb) ->
  query =
    _id: tile._id
  update =
    $set:
      message: message
  db.tiles.update query, update, cb
