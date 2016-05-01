_ = require 'underscore'
data = require '../../data'

module.exports.can = (character, tile, msg) ->
  terrain = data.terrains[tile.terrain]
  tags = terrain.tags ? []
  throw 'You cannot do that on this kind of terrain.' unless _.contains(tags, msg)
