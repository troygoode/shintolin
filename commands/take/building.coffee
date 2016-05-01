data = require '../../data'

module.exports.can = (character, tile, msg) ->
  throw "You must be in the presence of a #{data.buildings[msg].name} to do that." if msg isnt tile.building
