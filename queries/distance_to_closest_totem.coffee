_ = require 'underscore'
db = require '../db'
data = require '../data'
totem = data.buildings.totem
tiles_in_circle_around = require './tiles_in_circle_around'

module.exports = (center, search_radius, cb) ->
  tiles_in_circle_around center, search_radius, (err, tiles) ->
    return cb(err) if err?

    tiles_with_buildings = tiles.filter (t) ->
      t.building is totem.id

    with_distance = tiles_with_buildings.map (t) ->
      a = center.x + t.x
      b = center.y + t.y
      tile: t
      distance: Math.sqrt((a * a) + (b * b)) # Pythagoras yay!

    cb null, _.sortBy(with_distance, 'distance').reverse()
