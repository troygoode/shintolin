time = require '../../time'

module.exports =
  id: 'grassland'
  style: 'grass'

  buildable: ['tiny', 'small', 'large']

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
    modify_odds = (odds, mod) ->
      odds[key] = val * mod for key, val of odds
      odds
    odds =
      onion: .03
      wheat: .06
      thyme: .18
    if tile.searches < 6
      odds
    else if tile.searches < 12
      modify_odds odds, .75
    else if tile.searches < 18
      modify_odds odds, .5
    else
      null
