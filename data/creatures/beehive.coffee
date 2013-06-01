_ = require 'underscore'

module.exports =
  hp: 20

  attacked: (attacker, target, tile, weapon) ->
    roll = Math.random()
    if roll < .80
      accuracy: 1
      damage: 1
    else
      null

  loot: (attacker, target, tile, weapon) ->
    honeycomb: 3

  move: ->
    null

  is_habitable: (terrain, tile) ->
    _.contains(terrain.tags, 'trees')
