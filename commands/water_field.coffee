db = require '../db'

module.exports = (tile, cb) ->
  query =
    _id: tile._id
  update =
    $set:
      watered: true
  db.tiles.update query, update, false, false, cb
