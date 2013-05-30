time = require '../../time'

module.exports =
  name: 'stick'
  plural: 'sticks'
  tags: ['weapon']
  weight: 1

  weapon_class: 'blunt'
  break_odds: .1
  accuracy: (attacker, target, tile) ->
    .25
  damage: (attacker, target, tile) ->
    1

  modify_search_odds: (odds) ->
    switch time().season
      when 'Autumn' then odds * .8
      when 'Winter' then odds * .7
      else odds

  craft: (character, tile) ->
    takes:
      ap: 6
      tools: ['axe_stone']
      items:
        log: 1
    gives:
      items:
        stick: 6
      xp:
        crafter: 3
