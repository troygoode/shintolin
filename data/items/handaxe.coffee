module.exports =
  id: 'handaxe'
  name: 'hand axe'
  plural: 'hand axes'
  tags: ['weapon']
  weight: 2

  weapon_class: 'slash'
  break_odds: .02
  accuracy: (attacker, target, tile) ->
    if attacker.skills.indexOf 'axe_4' then .35
    else if attacker.skills.indexOf 'axe_2' then .25
    else .15
  damage: (attacker, target, tile) ->
    if attacker.skills.indexOf 'axe_3' then 3
    else if attacker.skills.indexOf 'axe_1' then 2
    else 1
