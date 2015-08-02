module.exports =
  name: 'stone spear'
  plural: 'stone spears'
  tags: ['weapon']
  weight: 5

  weapon_class: 'stab'
  break_odds: .02
  accuracy: (attacker, target, tile) ->
    chance = .10
    chance += .25 if attacker.skills.indexOf('spear_2') isnt -1
    chance += .25 if attacker.skills.indexOf('spear_4') isnt -1
    chance
  damage: (attacker, target, tile) ->
    dmg = 1
    dmg += 3 if attacker.skills.indexOf('spear_1') isnt -1
    dmg += 3 if attacker.skills.indexOf('spear_3') isnt -1
    dmg

  craft: (character, tile) ->
    takes:
      ap: 10
      skill: 'hafting'
      items:
        axe_hand: 1
        staff: 1
    gives:
      items:
        spear_stone: 1
      xp:
        crafter: 10
