module.exports =
  name: 'stone'
  plural: 'stones'
  tags: ['weapon']
  weight: 2

  weapon_class: 'blunt'
  break_odds: .02
  accuracy: (attacker, target, tile) ->
    .15
  damage: (attacker, target, tile) ->
    1
