time = require '../../time'

module.exports =
  name: 'piece of willow bark'
  plural: 'pieces of willow bark'
  weight: 0

  modify_search_odds: (odds) ->
    switch time().season
      when 'Autumn' then odds * .7
      when 'Winter' then odds * .5
      else odds
