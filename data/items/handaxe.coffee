module.exports =
  id: 'handaxe'
  name: 'hand axe'
  plural: 'hand axes'
  tags: ['weapon']
  weight: 2

  chop: true

  weapon_class: 'slash'
  break_odds: .02
  accuracy: (attacker, target, tile) ->
    chance = .15
    chance += .10 if attacker.skills.indexOf('axe_2') isnt -1
    chance += .10 if attacker.skills.indexOf('axe_4') isnt -1
    chance
  damage: (attacker, target, tile) ->
    dmg = 2
    dmg += 1 if attacker.skills.indexOf('axe_1') isnt -1
    dmg += 1 if attacker.skills.indexOf('axe_3') isnt -1
    dmg
