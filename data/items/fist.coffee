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
    .1
  damage: (attacker, target, tile) ->
    1
