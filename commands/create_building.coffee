async = require 'async'
db = require '../db'
queries = require '../queries'
create_tile = require './create_tile'

module.exports = (tile, building, cb) ->
  return cb('You cannot build a building inside a building.') if tile.z isnt 0 #Xyzzy shenanigans!
  return cb('Invalid Building') unless building?
  return cb('There is already a building here.') if tile.building? and not building.upgrade
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
      return cb() unless building.interior?
      coords =
        x: tile.x
        y: tile.y
        z: 1
      queries.get_tile_by_coords coords, (err, tile) ->
        return cb(err) if err?
        update_tile = (err, tile) ->
          return cb(err) if err?
          query =
            _id: tile._id
          update =
            $set:
              building: building.id
              terrain: building.interior
          db.tiles.update query, update, cb
        if tile?
          update_tile null, tile
        else
          create_tile coords, building.interior, update_tile
  ], cb
