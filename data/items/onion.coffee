time = require '../../time'

module.exports =
  name: 'wild onion'
  plural: 'wild onions'
  tags: ['usable', 'food']
  weight: 1

  modify_search_odds: (odds) ->
    switch time().season
      when 'Autumn' then odds * .7
      when 'Winter' then odds * .5
      else odds
