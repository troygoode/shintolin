_ = require 'underscore'

module.exports =
  plural: 'buffalo'
  hp: 100

  attacked: (attacker, target, tile, weapon) ->
    roll = Math.random()
    if roll < .15
      'flee'
    else if roll < .55
      accuracy: 1
      damage: 4
    else
      null

  loot: (attacker, target, tile, weapon) ->
    if _.contains(attacker.skills, 'butchering')
      pelt: 1
      meat_raw: 20
      horn: 2
    else
      pelt: 1
      meat_raw: 25
      horn: 2

  is_habitable: (terrain, tile) ->
    _.contains(terrain.tags, 'open')
