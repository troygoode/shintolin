time = require '../../time'

module.exports =
  style: 'hill3_top'

  buildable: ['tiny', 'small']

  describe: (tile) ->
    switch time().season
      when 'Spring'
        'You are atop a high hill, looking at the countryside stretching away in all directions.'
      when 'Summer'
        'You are atop a high hill, looking at the verdant countryside stretching away in all directions.'
      when 'Autumn'
        'You are atop a high hill, looking at the countryside slowly dissapearing into the autumn mist.'
      when 'Winter'
        'You are atop a high hill, looking at the countryside stretching away in all directions. A cold wind is blowing.'

  search_odds: (character, tile) ->
    flint: .25
    stone: .10

  altitude: 3
  cost_to_enter: (character, tile_from, tile_to, terrain_from, terrain_to) ->
    from_altitude = terrain_from.altitude ? 0
    if @altitude > from_altitude
      ((@altitude - from_altitude) * 2) - 1
    else
      0
