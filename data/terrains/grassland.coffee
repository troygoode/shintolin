time = require '../../time'

module.exports =
  id: 'grassland'
  style: 'grass'
  describe: (tile) ->
    switch time(new Date()).season
      when 'Spring'
        'You are walking through a verdant grassland. Some small flowers are starting to grow here.'
      when 'Summer'
        'You are walking through a verdant grassland, with many dandelions and other flowers. Crickets are chirping in the long grass.'
      when 'Autumn'
        'You are walking through a grassland. The cold weather is beginning to turn the grass brown.'
      when 'Winter'
        'You are walking through a grassland. Frost has hardened the ground, and there is little sign of life.'
  search_odds: (tile, character) ->
    onion: .03
    wheat: .06
    thyme: .18
