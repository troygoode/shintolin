in_square = require './tiles_in_square_around'

distance = (x1, y1, x2, y2) ->
  x3 = x2 - x1
  y3 = y2 - y2
  (x3 * x3) + (y3 * y3)

module.exports = (coords, radius, cb) ->
  in_square coords, radius, (err, tiles) ->
    return cb(err) if err?
    cb null, tiles.filter (t) ->
      distance(coords.x, coords.y, t.x, t.y) <= (radius * radius)
