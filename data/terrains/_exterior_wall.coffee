time = require '../../time'

module.exports =
  id: '_exterior_wall'
  style: 'wall'

  describe: (tile) ->
    switch time(new Date()).season
      when 'Spring'
        'You are standing high atop a stone wall. The wind roars, requiring all your strength to maintain your balance.'
      when 'Summer'
        'You are standing high atop a stone wall. Hot summer winds roar, requiring all your strength to maintain your balance.'
      when 'Autumn'
        'You are standing high atop a stone wall. The wind roars, requiring all your strength to maintain your balance.'
      when 'Winter'
        'You are standing high atop a stone wall. Icy winds batter your position, requiring all your strength to maintain your balance.'
