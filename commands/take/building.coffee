_ = require 'underscore'
data = require '../../data'

module.exports.can = (character, tile, msg) ->
  if typeof msg is 'string'
    msg = [msg]
  unless _.some(msg, (b) -> b is tile.building)
    throw "You cannot do that here."
