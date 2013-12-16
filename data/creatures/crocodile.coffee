_ = require 'underscore'

module.exports =
  hp: 100

  attacked: (attacker, target, tile, weapon) ->
    roll = Math.random()
    if roll < .10
      'flee'
    else if roll < .50
      accuracy: 1
      damage: 5
    else
      null

  loot: (attacker, target, tile, weapon) ->
    if _.contains(attacker.skills, 'butchering')
      pelt_croc: 1
      meat_raw: 7
    else
      pelt_croc: 1
      meat_raw: 10

  is_habitable: (terrain, tile) ->
    _.contains(terrain.tags, 'wetland') or _.contains(terrain.tags, 'shallow')
