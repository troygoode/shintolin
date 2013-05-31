_ = require 'underscore'

module.exports =
  name: 'wild boar'
  hp: 20

  attacked: (attacker, target, tile, weapon) ->
    roll = Math.random()
    if roll < .25
      'flee'
    else if roll < .5
      accuracy: 1
      damage: 2
    else
      null

  loot: (attacker, target, tile, weapon) ->
    if _.contains attacker.skills, 'butchering'
      pelt: 1
      meat_raw: 5
    else
      pelt: 1
      meat_raw: 3
