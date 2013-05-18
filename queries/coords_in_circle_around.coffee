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

distance = (coord1, coord2) ->
  x = coord2.x - coord1.x
  y = coord2.y - coord1.y
  Math.sqrt((x * x) + (y * y))

module.exports = (center, radius) ->
  square = in_square center, radius
  square.filter (coord) ->
    d = distance(center, coord)
    console.log "#{coord.x},#{coord.y}: #{d} <= #{radius}"
    d <= radius
    
