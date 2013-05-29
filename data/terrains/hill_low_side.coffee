time = require '../../time'

module.exports =
  style: 'hill1_side'

  describe: (tile) ->
    switch time().season
      when 'Spring'
        'You are on the side of a hill, at low elevation. A light breeze is blowing.'
      when 'Summer'
        'You are on the side of a hill, at low elevation. The hot sun shines down upon you.'
      when 'Autumn'
        'You are on the side of a hill, at low elevation. A stiff breeze is blowing.'
      when 'Winter'
        'You are on the side of a hill, at low elevation. A cold wind is blowing.'

  search_odds: (character, tile) ->
    flint: .10
    stone: .10

  altitude: 1
  cost_to_enter: (character, tile_from, tile_to, terrain_from, terrain_to) ->
    from_altitude = terrain_from.altitude ? 0
    if @altitude > from_altitude
      ((@altitude - from_altitude) * 2) - 1
    else
      0
