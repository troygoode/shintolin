time = require '../../time'

module.exports =
  name: 'handful of wheat'
  plural: 'handfuls of wheat'
  tags: ['usable', 'food', 'plantable']
  weight: 1

  modify_search_odds: (odds) ->
    switch time().season
      when 'Autumn' then odds * .5
      when 'Winter' then 0
      else odds
