_ = require 'underscore'
time = require '../../time'

module.exports =
  style: 'hill3_side'

  tags: ['hill']
  describe: (tile) ->
    switch time().season
      when 'Spring'
        'You are on the side of a hill, at high elevation. A light breeze is blowing.'
      when 'Summer'
        'You are on the side of a hill, at high elevation. The hot sun shines down upon you.'
      when 'Autumn'
        'You are on the side of a hill, at high elevation. A stiff breeze is blowing.'
      when 'Winter'
        'You are on the side of a hill, at high elevation. A cold wind is blowing.'

  search_odds: (character, tile) ->
    flint: .25
    stone: .10

  altitude: 3
  cost_to_enter: (character, tile_from, tile_to, terrain_from, terrain_to) ->
    from_altitude = terrain_from.altitude ? 0
    mountaineer = _.contains character.skills, 'mountaineer'
    if from_altitude >= @altitude
      0
    else if mountaineer
      2
    else
      ((@altitude - from_altitude) * 2) - 1
