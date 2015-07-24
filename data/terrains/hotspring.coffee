time = require '../../time'

module.exports =
  style: 'spring'
  block_spawning: true
  no_season: true

  tags: ['freshwater', 'shallow']
  actions: ['fill']

  describe: (tile) ->
    switch time().season
      when 'Spring'
        'You are bathing in a hot spring. Sulphurous-smelling water bubbles out from under the ground.'
      when 'Summer'
        'You are bathing in a hot spring. Sulphurous-smelling water bubbles out from under the ground.'
      when 'Autumn'
        'You are bathing in a hot spring. The heat of the water brings welcome relief from the chilly air.'
      when 'Winter'
        'You are bathing in a hot spring. The heat of the water brings welcome relief from the chilly air.'

  recovery: (character, tile) ->
    .5

  cost_to_enter: (character, tile_from, tile_to) ->
    2
