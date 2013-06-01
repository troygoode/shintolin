db = require '../db'
config = require '../config'

module.exports = (coords, terrain, region, cb) ->
  tile =
    x: coords.x
    y: coords.y
    z: coords.z ? 0
    region: region
    terrain: terrain ? config.default_terrain
    people: []
  db.tiles.insert tile, cb
