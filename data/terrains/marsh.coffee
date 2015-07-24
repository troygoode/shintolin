time = require '../../time'

module.exports =
  style: 'marsh'
  block_spawning: true
  no_season: true

  tags: ['wetland']

  describe: (tile) ->
    switch time().season
      when 'Spring'
        'You are wading through a marsh.'
      when 'Summer'
        'You are wading through a marsh.'
      when 'Autumn'
        'You are wading through a marsh. You can barely see anything through the thick mist.'
      when 'Winter'
        'You are wading through a marsh.'

  recovery: (character, tile) ->
    .5

  cost_to_enter: (character, tile_from, tile_to) ->
    .5
