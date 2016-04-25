async = require 'async'
Bluebird = require 'bluebird'
config = require '../config'
db = require '../db'
data = require '../data'
queries = require '../queries'
create_tile = require './create_tile'
BASE_RECOVERY = config.ap_per_hour

db.register_index db.tiles,
  x: 1
  y: 1
  z: 1

clean_coords = (coords) ->
  x: parseInt(coords.x)
  y: parseInt(coords.y)
  z: parseInt(coords.z ? 0)

get_tile = (coords, cb) ->
  return cb null, coords if coords._id?
  queries.get_tile_by_coords clean_coords(coords), cb

get_from = (character, from, cb) ->
  fallback = (cb) ->
    (err, tile) ->
      return cb(err) if err?
      cb null,
        x: character.x
        y: character.y
        z: character.z
  if from?._id?
    cb null, from
  else if from?
    console.log from
    get_tile from, fallback(cb)
  else
    get_tile
      x: character.x
      y: character.y
      z: character.z
    , fallback(cb)

module.exports = (character, from, to, cb) ->
  now = new Date()
  async.series [
    (cb) ->
      get_from character, from, cb
    (cb) ->
      get_tile to, cb
  ], (err, [from_tile, to_tile]) ->
    return cb(err) if err?

    recovery = 0

    async.series [
      (cb) ->
        queries.calculate_recovery(character, to_tile)
          .then (r) ->
            recovery = r
            cb null, r
          .catch (err) ->
            cb err
      (cb) ->
        query =
          _id: character._id
        update =
          $set:
            x: if to_tile then to_tile.x else to.x
            y: if to_tile then to_tile.y else to.y
            z: if to_tile then to_tile.z else to.z
            region: to_tile?.region
            recovery: recovery
        db.characters().updateOne query, update, cb
      (cb) ->
        query =
          x: from_tile.x
          y: from_tile.y
          z: from_tile.z
        update =
          $pull:
            people:
              _id: character._id
        db.tiles().updateOne query, update, cb
      (cb) ->
        if character.creature?
          update =
            $push:
              people:
                _id: character._id
                hp: character.hp
                hp_max: character.hp_max
                creature: character.creature
        else
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
          db.tiles().updateOne query, update, cb
        else
          query =
            x: to.x
            y: to.y
            z: to.z
          create_tile query, undefined, undefined, (err) ->
            return cb(err) if err?
            db.tiles().updateOne query, update, cb
    ], cb
