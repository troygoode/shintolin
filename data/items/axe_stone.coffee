module.exports =
  name: 'stone axe'
  plural: 'stone axes'
  tags: ['weapon', 'axe', 'chop']
  weight: 3

  weapon_class: 'slash'
  break_odds: .02
  accuracy: (attacker, target, tile) ->
    chance = .20
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
      ap: 10
      skill: 'hafting'
      items:
        axe_hand: 1
        stick: 1
    gives:
      items:
        axe_stone: 1
      xp:
        crafter: 10
