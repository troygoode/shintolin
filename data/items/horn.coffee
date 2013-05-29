module.exports =
  name: 'horn'
  plural: 'horns'
  weight: 3
  tags: ['weapon']

  weapon_class: 'stab'
  break_odds: .05
  accuracy: (attacker, target, tile) ->
    .2
  damage: (attacker, target, tile) ->
    2
