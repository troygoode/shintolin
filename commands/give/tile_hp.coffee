_ = require 'underscore'
async = require 'async'
db = require '../../db'
data = require '../../data'

bound_increase = (increase, current, max) ->
  if current > max
    0
  else if current + increase >= max
    max - current
  else
    increase

module.exports = (character, tile, msg) ->
  # grant building HP
  return  unless tile.building?
  building = data.buildings[tile.building]
  QUERY =
    _id: tile._id
  UPDATE =
    $inc:
      hp: bound_increase(msg, tile.hp, (building.hp_max ? building.hp))
  db.tiles().updateOne QUERY, UPDATE
