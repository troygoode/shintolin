_ = require 'underscore'
time = require '../../time'

module.exports =
  id: 'cliff_face_low'
  style: 'rshore'

  describe: (tile) ->
    'You are clinging to the side of a cliff, at low elevation.'

  altitude: 1
  cost_to_enter: (character, tile_from, tile_to, terrain_from, terrain_to) ->
    from_altitude = terrain_from.altitude ? 0
    if from_altitude >= @altitude
      0
    else if _.contains character.skills, 'mountaineering'
      7
    else
      null
