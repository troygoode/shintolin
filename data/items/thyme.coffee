time = require '../../time'

module.exports =
  name: 'thyme sprig'
  plural: 'thyme sprigs'
  tags: ['usable', 'heal']
  weight: 0

  modify_search_odds: (odds) ->
    switch time().season
      when 'Autumn' then odds * .7
      when 'Winter' then odds * .5
      else odds
