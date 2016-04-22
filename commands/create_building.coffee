async = require 'async'
db = require '../db'
queries = require '../queries'
create_tile = require './create_tile'

module.exports = (outside_tile, building, cb) ->
  return cb('You cannot build a building inside a building.') if outside_tile.z isnt 0 #Xyzzy shenanigans!
  return cb('Invalid Building') unless building?
  return cb('There is already a building here.') if outside_tile.building? and not building.upgrade
  async.series [
    (cb) ->
      # update current tile
      query =
        _id: outside_tile._id
      update =
        $set:
          building: building.id
          hp: building.hp
      db.tiles().updateOne query, update, cb
    , (cb) ->
      # create interior tile
      return cb() unless building.interior?
      coords =
        x: outside_tile.x
        y: outside_tile.y
        z: 1
      queries.get_tile_by_coords coords, (err, inside_tile) ->
        return cb(err) if err?
        update_tile = (err, inside_tile) ->
          return cb(err) if err?
          query =
            _id: inside_tile._id
          update =
            $set:
              building: building.id
              terrain: building.interior
          if outside_tile?.settlement_id
            update.$set.settlement_id = outside_tile.settlement_id
            update.$set.settlement_name = outside_tile.settlement_name
            update.$set.settlement_slug = outside_tile.settlement_slug
          db.tiles().updateOne query, update, cb
        if inside_tile?
          update_tile null, inside_tile
        else
          create_tile coords, building.interior, outside_tile.region, update_tile
  ], cb
