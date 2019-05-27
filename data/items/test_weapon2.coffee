module.exports =
  name: 'chain lightning'
  plural: 'chain lightning'
  tags: ['weapon', 'attack:building']
  weight: 1
  nodrop: true

  weapon_class: 'magic'
  break_odds: 0
  accuracy: (attacker, target, tile) ->
    1
  damage: (attacker, target, tile) ->
    200
