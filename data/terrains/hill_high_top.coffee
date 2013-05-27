time = require '../../time'

module.exports =
  id: 'hill_high_top'
  style: 'hill3_top'

  buildable: ['tiny', 'small']

  describe: (tile) ->
    switch time().season
      when 'Spring'
        'You are atop a high hill, looking at the countryside stretching away in all directions.'
      when 'Summer'
        'You are atop a high hill, looking at the verdant countryside stretching away in all directions.'
      when 'Autumn'
        'You are atop a high hill, looking at the countryside slowly dissapearing into the autumn mist.'
      when 'Winter'
        'You are atop a high hill, looking at the countryside stretching away in all directions. A cold wind is blowing.'

  search_odds: (tile, character) ->
    flint: .25
    stone: .10
