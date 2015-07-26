time = require '../../time'
define_loot_table = require '../../queries/loot_table_define'

module.exports =
  style: 'grass'

  tags: ['trail', 'open']
  buildable: ['tiny', 'small', 'large']
  actions: ['dig']

  describe: (tile) ->
    switch time().season
      when 'Spring'
        'You are walking through a verdant grassland. Some small flowers are starting to grow here.'
      when 'Summer'
        'You are walking through a verdant grassland, with many dandelions and other flowers. Crickets are chirping in the long grass.'
      when 'Autumn'
        'You are walking through a grassland. The cold weather is beginning to turn the grass brown.'
      when 'Winter'
        'You are walking through a grassland. Frost has hardened the ground, and there is little sign of life.'

  search_odds: (character, tile) ->
    define_loot_table character, tile,
      items:
        thyme: .18
        wheat: .06
        onion: .03

  dig_odds: (tile, character) ->
    define_loot_table character, tile,
      items:
        onion: .25

  shrink: (tile) ->
    'grassland_0'
