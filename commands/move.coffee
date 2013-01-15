async = require 'async'
db = require '../db'
queries = require '../queries'
create_tile = require './create_tile'

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

  query_character =
    _id: character._id
  update_character =
    $set: coords
  update_newtile =
    $push:
      people:
        id: character._id
        name: character.name
  update_oldtile =
    $pull:
      people:
        id: character._id
        name: character.name

  async.parallel [
    (cb) ->
      db.characters.update query_character, update_character, cb
    , (cb) ->
      queries.get_tile_by_coords coords, (err, tile) ->
        return cb(err) if err?
        if tile?
          db.tiles.update coords, update_newtile, cb
        else
          create_tile coords, 'wilderness', (err) ->
            return cb(err) if err?
            db.tiles.update coords, update_newtile, cb
    , (cb) ->
      db.tiles.update old_coords, update_oldtile, cb
  ], cb
