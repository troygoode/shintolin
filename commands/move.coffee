async = require 'async'
config = require '../config'
db = require '../db'
queries = require '../queries'
create_tile = require './create_tile'
data = require '../data'
teleport = require './teleport'
charge_ap = require './charge_ap'

db.register_index db.tiles,
  x: 1
  y: 1
  z: 1

module.exports = (character, direction, cb) ->
  old_coords =
    x: character.x
    y: character.y
    z: character.z

  coords = null
  switch direction
    when 'enter'
      coords =
        x: character.x
        y: character.y
        z: 1
    when 'exit'
      coords =
        x: character.x
        y: character.y
        z: 0
    when 'nw'
      coords =
        x: character.x - 1
        y: character.y - 1
        z: character.z
    when 'n'
      coords =
        x: character.x
        y: character.y - 1
        z: character.z
    when 'ne'
      coords =
        x: character.x + 1
        y: character.y - 1
        z: character.z
    when 'w'
      coords =
        x: character.x - 1
        y: character.y
        z: character.z
    when 'e'
      coords =
        x: character.x + 1
        y: character.y
        z: character.z
    when 'sw'
      coords =
        x: character.x - 1
        y: character.y + 1
        z: character.z
    when 's'
      coords =
        x: character.x
        y: character.y + 1
        z: character.z
    when 'se'
      coords =
        x: character.x + 1
        y: character.y + 1
        z: character.z
    else
      return cb 'Invalid direction.'

  async.parallel [
    (cb) ->
      queries.get_tile_by_coords coords, cb
    , (cb) ->
      queries.get_tile_by_coords old_coords, cb
  ], (err, [new_tile, old_tile]) ->
    return cb(err) if err?

    ap_cost = queries.cost_to_enter character, old_tile, new_tile
    return cb('You cannot move there.') unless ap_cost?

    return cb('Insufficient AP') unless character.ap >= ap_cost
    charge_ap character, ap_cost, (err) ->
      return cb(err) if err?
      teleport character, old_tile ? old_coords, new_tile ? coords, cb
