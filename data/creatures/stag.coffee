_ = require 'underscore'

module.exports =
  hp: 45

  attacked: (attacker, target, tile, weapon) ->
    roll = Math.random()
    if roll < .60
      'flee'
    else
      null

  loot: (attacker, target, tile, weapon) ->
    if _.contains attacker.skills, 'butchering'
      pelt: 1
      meat_raw: 10
      antler: 2
    else
      meat_raw: 13

  is_habitable: (terrain, tile) ->
    _.contains(terrain.tags, 'trees') or _.contains(terrain.tags, 'open')
