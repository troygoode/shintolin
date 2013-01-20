time = require '../../time'

module.exports =
  id: 'forest'
  style: 'forest'

  chop: true

  describe: (tile) ->
    switch time(new Date()).season
      when 'Spring'
        'You are in a forest. Shafts of sunlight shine through the trees.'
      when 'Summer'
        'You are in a forest. The leafy tree cover overhead provides some shade from the hot sun.'
      when 'Autumn'
        'You are in a forest, walking through a thick carpet of orange and brown leaves.'
      when 'Winter'
        'You are in a forest. The bare branches of the trees are stark against the winter sky.'

  search_odds: (tile, character) ->
    stick: .25
    staff: .08
    bark: .1
    chestnut: .15
