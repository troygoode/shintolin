_ = require 'underscore'

module.exports =
  hp: 200

  attacked: (attacker, target, tile, weapon) ->
    roll = Math.random()
    if roll < .08
      'flee'
    else if roll < .38
      accuracy: 1
      damage: 3
    else
      null

  loot: (attacker, target, tile, weapon) ->
    if _.contains(attacker.skills, 'butchering')
      pelt_bear: 1
      meat_raw: 25
    else
      pelt_bear: 1
      meat_raw: 20

  is_habitable: (terrain, tile) ->
    _.contains(terrain.tags, 'trees')
