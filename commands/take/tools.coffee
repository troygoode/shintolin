_ = require 'underscore'
data = require '../../data'

module.exports.can = (character, tile, msg) ->
  for tool in msg
    unless _.some(character.items, (i) -> i.item is tool)
      throw "You must have a #{data.items[tool].name} to do that."
