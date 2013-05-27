time = require '../../time'

module.exports =
  id: 'hill_mid_side'
  style: 'hill2_side'

  describe: (tile) ->
    switch time().season
      when 'Spring'
        'You are on the side of a hill, at medium elevation. A light breeze is blowing.'
      when 'Summer'
        'You are on the side of a hill, at medium elevation. The hot sun shines down upon you.'
      when 'Autumn'
        'You are on the side of a hill, at medium elevation. A stiff breeze is blowing.'
      when 'Winter'
        'You are on the side of a hill, at medium elevation. A cold wind is blowing.'

  search_odds: (tile, character) ->
    flint: .20
    stone: .10
