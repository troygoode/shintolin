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

    old_terrain = data.terrains[old_tile.terrain]
    if new_tile?
      new_terrain = data.terrains[new_tile.terrain]
    else
      new_terrain = data.terrains[config.default_terrain]

    if old_tile?.building?
      old_building = data.buildings[old_tile.building]
    if new_tile?.building?
      new_building = data.buildings[new_tile.building]

    ap_cost = 1
    if old_building?.cost_to_exit?
      extra = old_building.cost_to_exit(character, old_tile, new_tile, old_terrain, new_terrain)
      return cb('You cannot move there.') unless extra?
      ap_cost += extra
    if old_terrain.cost_to_exit?
      extra = old_terrain.cost_to_exit(character, old_tile, new_tile, old_terrain, new_terrain)
      return cb('You cannot move there.') unless extra?
      ap_cost += extra
    if new_terrain.cost_to_enter?
      extra = new_terrain.cost_to_enter(character, old_tile, new_tile, old_terrain, new_terrain)
      return cb('You cannot move there.') unless extra?
      ap_cost += extra
    if new_building?.cost_to_enter?
      extra = new_building.cost_to_enter(character, old_tile, new_tile, old_terrain, new_terrain)
      return cb('You cannot move there.') unless extra?
      ap_cost += extra

    return cb('Insufficient AP') unless character.ap >= ap_cost
    charge_ap character, ap_cost, (err) ->
      return cb(err) if err?
      teleport character, old_tile ? old_coords, new_tile ? coords, cb
