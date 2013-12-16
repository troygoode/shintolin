_ = require 'underscore'

module.exports =
  plural: 'wolves'
  hp: 50

  attacked: (attacker, target, tile, weapon) ->
    roll = Math.random()
    if roll < .45
      accuracy: 1
      damage: 3
    else
      null

  loot: (attacker, target, tile, weapon) ->
    if _.contains(attacker.skills, 'butchering')
      pelt_wolf: 1
      meat_raw: 6
    else
      pelt_wolf: 1
      meat_raw: 8

  is_habitable: (terrain, tile) ->
    _.contains(terrain.tags, 'trees') or _.contains(terrain.tags, 'open')
