time = require '../../time'

module.exports =
  id: 'stream'
  style: 'river'

  actions: ['fill']

  describe: (tile) ->
    switch time(new Date()).season
      when 'Spring'
        'You are wading through a small stream, cool water running over your feet.'
      when 'Summer'
        'You are paddling through a small stream. The water is slow and murky.'
      when 'Autumn'
        'You are wading through a small stream, cool water running over your feet.'
      when 'Winter'
        'You are wading through a small stream. The water is ice cold and rapid.'
