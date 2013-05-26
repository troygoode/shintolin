async = require 'async'
db = require '../db'
data = require '../data'
queries = require '../queries'
teleport = require './teleport'

remove_building = (tile) ->
  (cb) ->
    query =
      _id: tile._id
    update =
      $unset:
        building: true
        hp: true
        hq: true
    db.tiles.update query, update, cb

remove_interior = (tile, building) ->
  (cb) ->
    return cb() unless building.interior?
    async.series [
      (cb) ->
        old_coords =
          x: tile.x
          y: tile.y
          z: 1
        new_coords =
          x: tile.x
          y: tile.y
          z: 0
        db.characters.find(old_coords).toArray (err, characters) ->
          return cb(err) if err?
          async.forEach characters, (character, cb) ->
            teleport character, old_coords, new_coords, cb
          , cb
      , (cb) ->
        query =
          x: tile.x
          y: tile.y
          z: 1
        db.tiles.remove query, cb
    ], cb

module.exports = (tile, cb) ->
  return cb() unless tile.building?
  building = data.buildings[tile.building]
  async.series [
    remove_building(tile),
    remove_interior(tile, building)
  ], cb
