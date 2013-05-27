time = require '../../time'

module.exports =
  id: 'river_shallow'
  style: 'river'

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
      2
    else
      4
