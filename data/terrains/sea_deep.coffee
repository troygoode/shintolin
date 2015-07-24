_ = require 'underscore'
time = require '../../time'

module.exports =
  style: 'ocean'
  block_spawning: true
  no_season: true

  tags: ['saltwater', 'deep']
  actions: ['fill']

  describe: (tile) ->
    switch time().season
      when 'Spring'
        'You are swimming in the ocean. Animals are hiding behind the rocks (except the little fish).'
      when 'Summer'
        'You are swimming in the ocean. The cool water brings relief from the heat of the sun.'
      when 'Autumn'
        'You are swimming in the ocean.'
      when 'Winter'
        'You are swimming in the ocean. The cold water chills you to the bone.'

  cost_to_enter: (character, tile_from, tile_to) ->
    if _.contains character.skills, 'swimming'
      3
    else
      null
