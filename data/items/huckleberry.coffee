time = require '../../time'

module.exports =
  name: 'handful of huckleberries'
  plural: 'handfuls of huckleberries'
  tags: ['usable', 'food', 'plantable']
  weight: 1

  modify_search_odds: (odds) ->
    switch time().season
      when 'Spring' then odds * .3
      when 'Autumn' then odds * 1.5
      when 'Winter' then .5
      else odds
