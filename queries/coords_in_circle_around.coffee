in_square = (center, radius) ->
  x1 = center.x - radius
  x2 = center.x + radius
  y1 = center.y - radius
  y2 = center.y + radius
  ret = []
  for x in [x1..x2]
    for y in [y1..y2]
      ret.push x:x, y:y
  ret

in_circle = (coord1, coord2, radius) ->
  x = coord2.x - coord1.x
  y = coord2.y - coord1.y
  (x * x) + (y * y) <= radius * radius

module.exports = (center, radius) ->
  square = in_square center, radius
  square.filter (coord) ->
    in_circle center, coord, radius
