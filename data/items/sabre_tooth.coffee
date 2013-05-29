module.exports =
  name: 'sabre tooth'
  plural: 'sabre teeth'
  tags: ['weapon']
  weight: 2

  weapon_class: 'stab'
  break_odds: .02
  accuracy: (attacker, target, tile) ->
    .25
  damage: (attacker, target, tile) ->
    3
