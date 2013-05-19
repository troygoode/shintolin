db = require '../db'
config = require '../config'

module.exports = (coords, terrain, cb) ->
  tile =
    x: coords.x
    y: coords.y
    z: coords.z ? 0
    terrain: terrain ? config.default_terrain
    people: []
  db.tiles.insert tile, cb
