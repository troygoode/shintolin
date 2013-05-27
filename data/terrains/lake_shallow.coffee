time = require '../../time'

module.exports =
  id: 'lake_shallow'
  style: 'river'

  actions: ['fill']

  describe: (tile) ->
    switch time().season
      when 'Spring'
        'You are wading through shallow water, at the edge of a lake.'
      when 'Summer'
        'You are wading through the shallow edge of a lake. The cool water brings relief from the heat of the sun.'
      when 'Autumn'
        'You are wading through shallow water, at the edge of a lake.'
      when 'Winter'
        'You are wading through shallow water, at the edge of a lake. The ice cold water chills you to the bone.'

  cost_to_enter: (character, tile_from, tile_to) ->
    if _.contains character.skills, 'swimming'
      1
    else
      3
