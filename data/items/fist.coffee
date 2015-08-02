module.exports =
  name: 'your fists'
  plural: false
  tags: ['weapon']
  weight: 0
  nodrop: true
  intrinsic: true

  weapon_class: 'blunt'
  break_odds: 0
  accuracy: (attacker, target, tile) ->
    chance = .30
    chance += .15 if attacker.skills.indexOf('unarmed_1') isnt -1
    chance += .20 if attacker.skills.indexOf('unarmed_3') isnt -1
    chance
  damage: (attacker, target, tile) ->
    dmg = 2
    dmg += 1 if attacker.skills.indexOf('unarmed_2') isnt -1
    dmg += 3 if attacker.skills.indexOf('unarmed_4') isnt -1
    dmg

  text:
    suppress_indefinite_article: true
