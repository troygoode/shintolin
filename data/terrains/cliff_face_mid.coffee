_ = require 'underscore'
time = require '../../time'

module.exports =
  style: 'rshore'
  block_spawning: true

  describe: (tile) ->
    'You are clinging to the side of a cliff, at medium elevation.'

  altitude: 2
  cost_to_enter: (character, tile_from, tile_to, terrain_from, terrain_to) ->
    from_altitude = terrain_from.altitude ? 0
    mountaineer = _.contains character.skills, 'mountaineering'
    if from_altitude >= @altitude
      0
    else if mountaineer
      7
    else
      null
  cost_to_exit: (character, tile_from, tile_to, terrain_from, terrain_to) ->
    to_altitude = terrain_to.altitude ? 0
    mountaineer = _.contains character.skills, 'mountaineering'
    if to_altitude >= @altitude
      0
    else if mountaineer
      7
    else
      null
