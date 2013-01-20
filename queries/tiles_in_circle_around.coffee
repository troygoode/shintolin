in_square = require './tiles_in_square_around'

module.exports = (coords, radius, cb) ->
  in_square coords, radius, (err, tiles) ->
    return cb(err) if err?
    cb null, tiles
