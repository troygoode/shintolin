time = require '../../time'

module.exports =
  style: 'lightforest'

  tags: ['trees']
  buildable: ['tiny', 'small']
  actions: ['chop']

  describe: (tile) ->
    switch time().season
      when 'Autumn'
        'A number of tall pine trees tower above you here, and pine cones crunch underfoot.'
      when 'Winter'
        'A number of tall pine trees tower above you here, with snow hanging off the branches of the trees.'
      else
        'A number of tall pine trees tower above you here.'

  search_odds: (character, tile) ->
    stick: .25
    chestnut: .07
    bark: .05
    staff: .08

  grow: (tile) ->
    odds = switch time().season
      when 'Spring'
        .25
      when 'Summer'
        .40
    return null unless odds > 0
    return 'forest_pine_3' if Math.random() < odds
  shrink: (tile) ->
    'forest_pine_1'
