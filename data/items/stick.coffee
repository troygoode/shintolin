module.exports =
  id: 'stick'
  name: 'stick'
  plural: 'sticks'
  tags: ['weapon']
  weight: 1

  weapon_class: 'blunt'
  break_odds: .1
  accuracy: (attacker, target, tile) ->
    .25
  damage: (attacker, target, tile) ->
    1
