module.exports =
  name: 'hand axe'
  plural: 'hand axes'
  tags: ['weapon', 'axe', 'harvest', 'chop', 'write']
  weight: 2

  weapon_class: 'slash'
  break_odds: .035
  accuracy: (attacker, target, tile) ->
    chance = .40
    chance += .10 if attacker.skills.indexOf('axe_2') isnt -1
    chance += .10 if attacker.skills.indexOf('axe_4') isnt -1
    chance
  damage: (attacker, target, tile) ->
    dmg = 1
    dmg += 1 if attacker.skills.indexOf('axe_1') isnt -1
    dmg += 1 if attacker.skills.indexOf('axe_3') isnt -1
    dmg

  craft: (character, tile) ->
    takes:
      ap: 10
      tools: ['stone']
      items:
        flint: 1
    gives:
      items:
        axe_hand: 1
      xp:
        crafter: 10
