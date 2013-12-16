_ = require 'underscore'

module.exports =
  name: 'mountain lion'
  hp: 70

  attacked: (attacker, target, tile, weapon) ->
    roll = Math.random()
    if roll < .45
      accuracy: 1
      damage: 3
    else
      null

  loot: (attacker, target, tile, weapon) ->
    if _.contains(attacker.skills, 'butchering')
      pelt_lion: 1
      meat_raw: 8
    else
      pelt_lion: 1
      meat_raw: 10

  is_habitable: (terrain, tile) ->
    _.contains(terrain.tags, 'open') or _.contains(terrain.tags, 'hill')
