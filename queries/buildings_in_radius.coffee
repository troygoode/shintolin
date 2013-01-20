db = require '../db'
tiles_in_circle_around = require './tiles_in_circle_around'

module.exports = (center, radius, building, cb) ->
  tiles_in_circle_around center, radius, (err, tiles) ->
    return cb(err) if err?
    tiles_with_buildings = tiles.filter (t) ->
      t.building is building.id
    cb null, tiles_with_buildings.length
