time = require '../../time'

module.exports =
  id: 'forest_1'
  style: 'lightforest'

  buildable: ['tiny', 'small']
  actions: ['chop']

  describe: (tile) ->
    switch time().season
      when 'Spring'
        'You are walking though an open woodland.'
      when 'Summer'
        'You are walking though an open woodland.'
      when 'Autumn'
        'You are walking though an open woodland, the leaves turning golden and brown with autumn.'
      when 'Winter'
        'You are walking though an open woodland. The tree branches are bare.'

  search_odds: (tile, character) ->
    stick: .25
    chestnut: .15
    bark: .10
    staff: .08
