_ = require 'underscore'

module.exports =
  name: 'sabretooth tiger'
  hp: 100

  attacked: (attacker, target, tile, weapon) ->
    roll = Math.random()
    if roll < .45
      accuracy: 1
      damage: 5
    else
      null

  loot: (attacker, target, tile, weapon) ->
    if _.contains(attacker.skills, 'butchering')
      pelt: 1
      sabre_tooth: 2
      meat_raw: 10
    else
      pelt: 1
      sabre_tooth: 2
      meat_raw: 13

  is_habitable: (terrain, tile) ->
    _.contains(terrain.tags, 'trees')
