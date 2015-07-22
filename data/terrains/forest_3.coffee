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
        'You are in a forest. Shafts of sunlight shine through the trees.'
      when 'Summer'
        'You are in a forest. The leafy tree cover overhead provides some shade from the hot sun.'
      when 'Autumn'
        'You are in a forest, walking through a thick carpet of orange and brown leaves.'
      when 'Winter'
        'You are in a forest. The bare branches of the trees are stark against the winter sky.'

  search_odds: (character, tile) ->
    stick: .25
    chestnut: .15
    bark: .10
    staff: .08

  cost_to_enter: (character, tile_from, tile_to) ->
    if _.contains character.skills, 'forest_walk'
      0
    else
      1

  grow: (tile) ->
    odds = switch time().season
      when 'Spring'
        .15
      when 'Summer'
        .30
    return null unless odds > 0
    return 'forest_4' if Math.random() < odds
  shrink: (tile) ->
    'forest_2'
