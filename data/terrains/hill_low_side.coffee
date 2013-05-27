time = require '../../time'

module.exports =
  id: 'hill_low_side'
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

  search_odds: (tile, character) ->
    flint: .1
    stone: .1
