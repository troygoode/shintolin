_ = require 'underscore'
time = require '../../time'

module.exports =
  style: 'river'
  block_spawning: true
  no_season: true

  tags: ['freshwater', 'shallow']
  actions: ['fill']

  describe: (tile) ->
    switch time().season
      when 'Spring'
        'You are wading through a small river, cool water running over your feet.'
      when 'Summer'
        'You are paddling through a small river. The water is slow and murky.'
      when 'Autumn'
        'You are wading through a small river, cool water running over your feet.'
      when 'Winter'
        'You are wading through a small river. The water is ice cold and rapid.'

  cost_to_enter: (character, tile_from, tile_to) ->
    if _.contains character.skills, 'swimming'
      1
    else
      3
