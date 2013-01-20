module.exports =
  id: 'handaxe'
  name: 'hand axe'
  plural: 'hand axes'
  tags: ['weapon']
  weight: 2

  weapon_class: 'slash'
  break_odds: .02
  accuracy: (attacker, target, tile) ->
    .15
  damage: (attacker, target, tile) ->
    2
