_ = require 'underscore'
time = require '../../time'

module.exports =
  id: 'forest_3'
  style: 'denseforest'

  buildable: ['tiny', 'small']
  actions: ['chop']

  describe: (tile) ->
    switch time().season
      when 'Spring'
        'You are in a dense forest. Almost no light can be seen through the thick tree cover overhead.'
      when 'Summer'
        'You are in a dense forest. Almost no light can be seen through the thick tree cover overhead.'
      when 'Autumn'
        'You are in a dense forest. The thick tree cover overhead is russet and gold in colour.'
      when 'Winter'
        'You are in a dense forest. The bare branches form a thick tangle overhead.'

  search_odds: (character, tile) ->
    stick: .25
    chestnut: .15
    bark: .10
    staff: .08

  cost_to_enter: (character, tile_from, tile_to) ->
    if _.contains character.skills, 'forest_walk'
      1
    else
      2

  shrink: (tile) ->
    'forest_2'
