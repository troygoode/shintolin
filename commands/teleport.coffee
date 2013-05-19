async = require 'async'
db = require '../db'
queries = require '../queries'
create_tile = require './create_tile'

get_tile = (coords, cb) ->
  return cb null, coords if coords._id?
  queries.get_tile_by_coords coords, cb

get_from = (character, from, cb) ->
  if from?._id?
    cb null, from
  else if from?
    get_tile from, cb
  else
    get_tile
      x: character.x
      y: character.y
      z: character.z
    , cb

module.exports = (character, from, to, cb) ->
  now = new Date()
  async.parallel [
    (cb) ->
      get_from character, from, cb
    , (cb) ->
      get_tile to, cb
  ], (err, [from_tile, to_tile]) ->
    return cb(err) if err?
    async.parallel [
      (cb) ->
        query =
          _id: character._id
        update =
          $set:
            x: to.x
            y: to.y
            z: to.z
        db.characters.update query, update, cb
      , (cb) ->
        update =
          $push:
            people:
              _id: character._id
              name: character.name
              slug: character.slug
              hp: character.hp
              hp_max: character.hp_max
        update.$push.people.settlement_id = character.settlement_id if character.settlement_id?
        if to_tile?
          query =
            _id: to_tile._id
          db.tiles.update query, update, cb
        else
          query =
            x: to.x
            y: to.y
            z: to.z
          create_tile query, undefined, (err) ->
            return cb(err) if err?
            db.tiles.update query, update, cb
      , (cb) ->
        #TODO: remove old tile if wilderness, has no people, not in settlement
        query =
          x: from_tile.x
          y: from_tile.y
          z: from_tile.z
        update =
          $pull:
            people:
              _id: character._id
        db.tiles.update query, update, false, true, cb
    ], cb
