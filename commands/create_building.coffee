async = require 'async'
db = require '../db'
create_tile = require './create_tile'

module.exports = (tile, building, cb) ->
  return cb('Xyzzy shenanigans') if tile.z isnt 0 # no building huts inside of huts :-)
  return cb('Invalid Building') unless building?
  return cb('There is already a building here.') if tile.building?
  async.series [
    (cb) ->
      # update current tile
      query =
        _id: tile._id
      update =
        $set:
          building: building.id
          hp: building.hp
      db.tiles.update query, update, cb
    , (cb) ->
      # create interior tile
      # TODO: should the interior tile know what kind of building it is?
      return cb() unless building.interior?
      coords =
        x: tile.x
        y: tile.y
        z: 1
      create_tile coords, building.interior, cb
  ], cb
