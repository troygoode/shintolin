_ = require 'underscore'

module.exports =
  hp: 6

  attacked: (attacker, target, tile, weapon) ->
    roll = Math.random()
    if roll < .80
      'flee'
    else if roll < .90
      accuracy: 1
      damage: 1
    else
      null

  loot: (attacker, target, tile, weapon) ->
    if _.contains(attacker.skills, 'butchering')
      pelt_small: 1
      meat_raw: 1
    else
      pelt_small: 1
      meat_raw: 2

  is_habitable: (terrain, tile) ->
    _.contains(terrain.tags, 'trees')
