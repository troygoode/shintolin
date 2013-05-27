module.exports =
  id: 'stick'
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
