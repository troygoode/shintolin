time = require '../../time'

module.exports =
  id: 'wilderness'
  style: 'wilderness'
  hidden: true
  describe: (tile) ->
    switch time(new Date()).season
      when 'Spring'
        'You are wandering through a seemingly endless wilderness.'
      when 'Summer'
        'You are wandering through a seemingly endless wilderness. The hot sun beats down upon you.'
      when 'Autumn'
        'You are wandering through a seemingly endless wilderness.'
      when 'Winter'
        'You are wandering through a seemingly endless wilderness. A cold wind whistles through the desolate landscape.'

  #example
  cost_to_enter: (tile_to, tile_from, character) ->
    1
