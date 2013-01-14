db = require '../db'
queries = require '../queries'
create_tile = require './create_tile'

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
      create_tile character, terrain, cb
