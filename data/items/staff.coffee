module.exports =
  id: 'staff'
  name: 'staff'
  plural: 'staves'
  tags: ['weapon']
  weight: 3

  weapon_class: 'blunt'
  break_odds: .05
  accuracy: (attacker, target, tile) ->
    .25
  damage: (attacker, target, tile) ->
    2
