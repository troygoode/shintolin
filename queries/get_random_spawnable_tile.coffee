config = require '../config'
data = require '../data'
get_random_tile = require './get_random_tile'
MAX_RECURSE = 100

is_spawnable = (tile) ->
  terrain = data.terrains[tile.terrain ? config.default_terrain]
  region = data.regions[tile.region] ? {}
  #TODO: restrict spawning with certain settlements?
  return terrain.block_spawning isnt true and region.block_spawning isnt true

module.exports = (cb) ->
  recurse = (counter, cb) ->
    return cb('MAX_RANDOM_TILE_RECURSION') unless counter < MAX_RECURSE
    get_random_tile (err, tile) ->
      return cb(err) if err?
      if is_spawnable(tile)
        cb null, tile
      else
        recurse counter + 1, cb

  recurse 0, cb
