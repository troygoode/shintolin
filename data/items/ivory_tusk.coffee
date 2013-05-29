module.exports =
  name: 'mammoth tusk'
  plural: 'mammoth tusks'
  tags: ['weapon']
  weight: 8

  weapon_class: 'stab'
  break_odds: .05
  accuracy: (attacker, target, tile) ->
    .20
  damage: (attacker, target, tile) ->
    6
