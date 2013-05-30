_ = require 'underscore'
time = require '../../time'

module.exports =
  style: 'hill2_top'

  buildable: ['tiny', 'small']

  describe: (tile) ->
    switch time().season
      when 'Spring'
        'You are atop a medium hill, looking at the countryside stretching away in all directions.'
      when 'Summer'
        'You are atop a medium hill, looking at the verdant countryside stretching away in all directions.'
      when 'Autumn'
        'You are atop a medium hill, looking at the countryside slowly dissapearing into the autumn mist.'
      when 'Winter'
        'You are atop a medium hill, looking at the countryside stretching away in all directions. A cold wind is blowing.'

  search_odds: (character, tile) ->
    flint: .20
    stone: .10

  altitude: 2
  cost_to_enter: (character, tile_from, tile_to, terrain_from, terrain_to) ->
    from_altitude = terrain_from.altitude ? 0
    mountaineer = _.contains character.skills, 'mountaineer'
    if from_altitude >= @altitude
      0
    else if mountaineer
      2
    else
      ((@altitude - from_altitude) * 2) - 1
