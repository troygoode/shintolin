_ = require 'underscore'
time = require '../../time'

module.exports =
  id: 'forest_pine_3'
  style: 'denseforest'

  buildable: ['tiny', 'small']
  actions: ['chop']

  describe: (tile) ->
    switch time().season
      when 'Summer'
        'You are in an evergreen forest. Sunlight barely penetrates the thick tangle of pine branches overhead.'
      when 'Winter'
        'You are in a dense pine forest. Snow hangs heavy on the branches of the trees.'
      else
        'You are walking through a dense evergreen forest, your journey hampered by a thick wall of pine branches.'

  search_odds: (character, tile) ->
    stick: .25
    staff: .08

  cost_to_enter: (character, tile_from, tile_to) ->
    if _.contains character.skills, 'forest_walk'
      1
    else
      2

  shrink: (tile) ->
    'forest_pine_2'
