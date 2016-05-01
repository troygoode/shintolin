db = require '../../db'
data = require '../../data'

bound_decrease = (decrease, current, min) ->
  if current - decrease >= min
    decrease
  else
    current - min

module.exports.take = (character, tile, msg) ->
  building = data.buildings[tile.building]
  query =
    _id: tile._id
  update =
    $inc:
      hp: 0 - bound_decrease(msg, tile.hp, 0)
  db.tiles().updateOne query, update
