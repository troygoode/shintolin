async = require 'async'
db = require '../db'
queries = require '../queries'
create_tile = require './create_tile'

module.exports = (character, cb) ->
  finish = (tile) ->
    async.parallel [
      (cb) ->
        db.characters.insert character, cb
      , (cb) ->
        query =
          _id: tile._id
        update =
          $push:
            people:
              _id: character._id
              name: character.name
              hp: character.hp
              hp_max: character.hp_max
        db.tiles.update query, update, cb
    ], (err, [character]) ->
      cb err, character
  queries.get_tile_by_coords character, (err, tile) ->
    return cb(err) if err?
    if tile?
      finish tile
    else
      create_tile character, 'wilderness', (err, tile) ->
        return cb(err) if err?
        finish tile
