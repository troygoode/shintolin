_ = require 'underscore'
time = require '../../time'

module.exports =
  style: 'forest'

  tags: ['trees']
  buildable: ['tiny', 'small']
  actions: ['chop']

  describe: (tile) ->
    switch time().season
      when 'Spring'
        'You are in an evergreen forest. Tall pine trees tower above you.'
      when 'Summer'
        'You are in an evergreen forest. Shafts of sunlight shine through the tall pine trees.'
      when 'Autumn'
        'You are in an evergreen forest. Pine cones crunch underfoot.'
      when 'Winter'
        'You are in a pine forest. Snow hangs heavy on the branches of the trees.'

  search_odds: (character, tile) ->
    stick: .25
    staff: .08

  cost_to_enter: (character, tile_from, tile_to) ->
    if _.contains character.skills, 'forest_walk'
      0
    else
      1

  grow: (tile) ->
    odds = switch time().season
      when 'Spring'
        .25
      when 'Summer'
        .40
    return null unless odds > 0
    return 'forest_pine_4' if Math.random() < odds
  shrink: (tile) ->
    'forest_pine_2'
