time = require '../../time'
define_loot_table = require '../../queries/loot_table_define'

module.exports =
  style: 'lightgrey'

  tags: ['open']
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
    define_loot_table character, tile,
      items:
        flint: .15
        huckleberry: .15
        stone: .10
