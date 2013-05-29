db = require '../db'

module.exports = (tile, terrain, region, cb) ->
  query =
    _id: tile._id
  if region?.length
    update =
      $set:
        terrain: terrain
        region: region
  else
    update =
      $set:
        terrain: terrain
      $unset:
        region: true
  db.tiles.update query, update, cb
