module.exports =
  name: 'ivory axe'
  plural: 'ivory axes'
  tags: ['weapon', 'axe', 'chop']
  weight: 8

  weapon_class: 'slash'
  break_odds: .0025
  accuracy: (attacker, target, tile) ->
    chance = .75
    chance += .10 if attacker.skills.indexOf('axe_2') isnt -1
    chance += .10 if attacker.skills.indexOf('axe_4') isnt -1
    chance
  damage: (attacker, target, tile) ->
    dmg = 2
    dmg += 1 if attacker.skills.indexOf('axe_1') isnt -1
    dmg += 1 if attacker.skills.indexOf('axe_3') isnt -1
    dmg

  craft: (character, tile) ->
    takes:
      ap: 15
      skill: 'hafting'
      tools: ['stone']
      items:
        ivory_tusk: 1
        stick: 1
        pelt_small: 1
    gives:
      items:
        axe_ivory: 1
      xp:
        crafter: 15
