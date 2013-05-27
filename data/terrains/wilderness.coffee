time = require '../../time'

module.exports =
  id: 'wilderness'
  style: 'wilderness'
  hidden: true
  describe: (tile) ->
    switch time().season
      when 'Spring'
        'You are wandering through a seemingly endless wilderness.'
      when 'Summer'
        'You are wandering through a seemingly endless wilderness. The hot sun beats down upon you.'
      when 'Autumn'
        'You are wandering through a seemingly endless wilderness.'
      when 'Winter'
        'You are wandering through a seemingly endless wilderness. A cold wind whistles through the desolate landscape.'

  #example
  cost_to_enter: (character, tile_from, tile_to) ->
    0 # this is in addition to the base of 1 and the cost to exit prior tile, returning null will prevent entry
