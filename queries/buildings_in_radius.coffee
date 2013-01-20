db = require '../db'
tiles_in_square_around = require './tiles_in_square_around'

module.exports = (center, radius, building, cb) ->
  tiles_in_square_around center, radius, (err, tiles) ->
    return cb(err) if err?

    #TODO: make this do a circular check rather than a square check
    tiles_with_buildings = tiles.filter (t) ->
      t.building is building.id
    cb null, tiles_with_buildings.length
