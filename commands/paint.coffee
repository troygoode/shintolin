db = require '../db'
queries = require '../queries'

module.exports = (character, terrain, cb) ->
  queries.get_tile_by_coords character, (err, tile) ->
    return cb(err) if err?
    if tile?
      query =
        _id: tile._id
      update =
        $set:
          terrain: terrain
      db.tiles.update query, update, cb
    else
      tile =
        x: character.x
        y: character.y
        z: character.z
        terrain: terrain
      db.tiles.insert tile, cb
