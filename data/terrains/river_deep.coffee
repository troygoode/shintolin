_ = require 'underscore'
time = require '../../time'

module.exports =
  style: 'ocean'
  block_spawning: true
  no_season: true

  tags: ['freshwater', 'deep']

  describe: (tile) ->
    switch time().season
      when 'Spring'
        'You are swimming through a deep river.'
      when 'Summer'
        'You are swimming through a deep river. The cool water brings relief from the heat of the sun.'
      when 'Autumn'
        'You are swimming through a deep river.'
      when 'Winter'
        'You are swimming through a deep river. The cold water chills you to the bone.'

  cost_to_enter: (character, tile_from, tile_to) ->
    if _.contains character.skills, 'swimming'
      3
    else
      null
