db = require '../db'

module.exports = (tile, building, cb) ->
  query =
    _id: tile._id
  update =
    $set:
      building: building.id
      hp: building.hp
  db.tiles.update query, update, cb
