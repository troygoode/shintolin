_ = require 'underscore'
time = require '../../time'

module.exports =
  style: 'river'
  block_spawning: true

  tags: ['saltwater', 'shallow']
  actions: ['fill']

  describe: (tile) ->
    switch time().season
      when 'Spring'
        'You are paddling through shallow water, at the edge of an ocean that stretches to the horizon. Waves crash against the shore.'
      when 'Summer'
        'You are paddling through shallow water, at the edge of an ocean that stretches to the horizon. Sunlight glints off the crest of the waves.'
      when 'Autumn'
        'You are paddling through shallow water, at the edge of an ocean that stretches to the horizon. Waves crash against the shore.'
      when 'Winter'
        'You are paddling through shallow water, at the edge an ocean that stretches to the horizon. Violent waves crash against the shore, sending up a spray of salt water.'

  cost_to_enter: (character, tile_from, tile_to) ->
    if _.contains character.skills, 'swimming'
      1
    else
      3
