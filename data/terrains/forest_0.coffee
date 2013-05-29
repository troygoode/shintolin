time = require '../../time'

module.exports =
  style: 'grass'

  buildable: ['tiny', 'small']
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
    thyme: .18
    wheat: .06
    onion: .03

  grow: (tile) ->
    odds = switch time().season
      when 'Spring'
        .10
    return null unless odds > 0
    return 'forest_1' if Math.random() < odds

  dig_odds: (character, tile) ->
    onion: .25
