module.exports =
  name: 'hammer of the gods'
  plural: 'hammers of the gods'
  tags: ['weapon']
  weight: 1
  nodrop: true

  weapon_class: 'blunt'
  break_odds: 0
  accuracy: (attacker, target, tile) ->
    1
  damage: (attacker, target, tile) ->
    10
