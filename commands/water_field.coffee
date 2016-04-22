db = require '../db'

module.exports = (tile, cb) ->
  query =
    _id: tile._id
  update =
    $set:
      watered: true
  db.tiles().updateOne query, update, cb
