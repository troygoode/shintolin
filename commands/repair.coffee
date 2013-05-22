db = require '../db'
data = require '../data'

module.exports = (character, tile, cb) ->
  return cb('You cannot repair a tile without a building.') unless tile.building?
  building = data.buildings[tile.building]
  return cb('You cannot repair this kind of building.') unless building?.repair?

  result = building.repair(character, tile)
  return cb() unless result?

  cb()
