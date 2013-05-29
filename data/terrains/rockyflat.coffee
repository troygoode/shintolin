time = require '../../time'

module.exports =
  style: 'lightgrey'

  buildable: ['tiny', 'small', 'large']

  describe: (tile) ->
    switch time().season
      when 'Spring'
        'This area is almost devoid of vegetation, with many rocks scattered around.'
      when 'Summer'
        'This area is almost devoid of vegetation, with many rocks scattered across the dusty ground.'
      when 'Autumn'
        'This area is almost devoid of vegetation, with many rocks scattered around.'
      when 'Winter'
        'This area is almost devoid of vegetation, with many rocks scattered around. A cold wind howls through the desolate landscape.'

  search_odds: (character, tile) ->
    flint: .15
    huckleberry: .15
    stone: .10
