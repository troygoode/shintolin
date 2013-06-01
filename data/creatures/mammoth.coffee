_ = require 'underscore'

module.exports =
  hp: 750

  attacked: (attacker, target, tile, weapon) ->
    roll = Math.random()
    if roll < .15
      'flee'
    else if roll < .85
      accuracy: 1
      damage: 8
    else
      null

  loot: (attacker, target, tile, weapon) ->
    if _.contains attacker.skills, 'butchering'
      ivory_tusk: 2
      meat_raw: 65
    else
      ivory_tusk: 2
      meat_raw: 82
