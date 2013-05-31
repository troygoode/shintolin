_ = require 'underscore'
data = require '../data'
db = require '../db'
queries = require '../queries'
teleport = require './teleport'

random_direction = (tiles) ->
  index = Math.floor(Math.random() * tiles.length)
  tiles[index]

module.exports = (creature, cb) ->
  creature_type = data.creatures[creature.creature]
  queries.get_tile_by_coords creature, (err, center) ->
    return cb(err) if err?
    queries.tiles_in_square_around center, 1, (err, tiles) ->
      return cb(err) if err?
      tiles = _.filter tiles, (t) ->
        not (t.x is creature.x and t.y is creature.y and t.z is creature.z)

      pick_direction = creature_type.move ? random_direction
      new_tile = pick_direction tiles
      teleport creature, center, new_tile, cb
