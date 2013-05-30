time = require '../../time'

module.exports =
  name: 'staff'
  plural: 'staves'
  tags: ['weapon']
  weight: 3

  weapon_class: 'blunt'
  break_odds: .05
  accuracy: (attacker, target, tile) ->
    .25
  damage: (attacker, target, tile) ->
    2

  craft: (character, tile) ->
    takes:
      ap: 12
      tools: ['stone_carpentry']
      skill: 'carpentry'
      items:
        log: 1
    gives:
      items:
        staff: 3
      xp:
        crafter: 5

  modify_search_odds: (odds) ->
    switch time().season
      when 'Autumn' then odds * .8
      when 'Winter' then odds * .7
      else odds
