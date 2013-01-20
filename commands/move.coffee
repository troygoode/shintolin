async = require 'async'
db = require '../db'
queries = require '../queries'
create_tile = require './create_tile'
data = require '../data'

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
      new_terrain = data.terrains.wilderness
    if new_terrain.cost_to_enter?
      ap_cost = new_terrain.cost_to_enter new_tile, old_tile, character
    else
      ap_cost = 1
    return cb('Insufficient AP') unless character.ap >= ap_cost
    async.parallel [
      (cb) ->
        query_character =
          _id: character._id
        update_character =
          $set:
            x: coords.x
            y: coords.y
            z: coords.z
            last_action: new Date()
          $inc:
            ap: 0 - ap_cost
        db.characters.update query_character, update_character, cb
      , (cb) ->
        update_newtile =
          $push:
            people:
              _id: character._id
              name: character.name
              slug: character.slug
              hp: character.hp
              hp_max: character.hp_max
        if new_tile?
          db.tiles.update coords, update_newtile, cb
        else
          create_tile coords, 'wilderness', (err) ->
            return cb(err) if err?
            db.tiles.update coords, update_newtile, cb
      , (cb) ->
        query =
          old_coords
        update =
          $pull:
            people:
              _id: character._id
              name: {$exists: true}
              slug: {$exists: true}
              hp: {$exists: true}
              hp_max: {$exists: true}
        db.tiles.update query, update, false, true, cb
    ], cb
