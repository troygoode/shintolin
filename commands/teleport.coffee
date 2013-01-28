async = require 'async'
db = require '../db'
create_tile = require './create_tile'

#TODO: remove old tile if wilderness, has no people, not in settlement

module.exports = (character, from, to, cb) ->
  now = new Date()
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
      if to._id?
        query =
          _id: to._id
        db.tiles.update query, update, cb
      else
        create_tile coords, 'wilderness', (err) ->
          return cb(err) if err?
          query =
            x: to.x
            y: to.y
            z: to.z
          db.tiles.update query, update, cb
    , (cb) ->
      query =
        x: from.x
        y: from.y
        z: from.z
      update =
        $pull:
          people:
            _id: character._id
      db.tiles.update query, update, false, true, cb
  ], cb
