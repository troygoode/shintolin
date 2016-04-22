_ = require 'underscore'
data = require '../data'
queries = require '../queries'
teleport = require './teleport'

random_direction = (creature_type) ->
  (tiles) ->
    _tiles = tiles

    if creature_type.is_habitable?
      _tiles = _tiles.filter (t) ->
        creature_type.is_habitable data.terrains[t.terrain], t
      _tiles = tiles unless _tiles.length # if it has no valid moves, let it move anywhere

    return null unless _tiles?.length
    index = Math.floor(Math.random() * _tiles.length)
    _tiles[index]

module.exports = (creature, cb) ->
  creature_type = data.creatures[creature.creature]
  queries.get_tile_by_coords creature, (err, center) ->
    return cb(err) if err?
    queries.tiles_in_square_around center, 1, (err, tiles) ->
      return cb(err) if err?
      tiles = _.filter tiles, (t) ->
        not (t.x is creature.x and t.y is creature.y and t.z is creature.z)

      pick_direction = creature_type.move ? random_direction(creature_type)
      new_tile = pick_direction tiles
      return cb() unless new_tile?
      teleport creature, center, new_tile, cb
