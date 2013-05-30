time = require '../../time'

module.exports =
  name: 'handful of chestnuts'
  plural: 'handfuls of chestnuts'
  tags: ['usable', 'food']
  weight: 1

  modify_search_odds: (odds) ->
    switch time().season
      when 'Autumn' then odds * 1.3
      when 'Winter' then odds * .5
      else odds
