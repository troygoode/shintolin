_ = require 'underscore'
async = require 'async'
data = require '../data'
db = require '../db'

module.exports = (creature, tile, cb) ->
  now = new Date()
  async.waterfall [
    (cb) ->
      character =
        creature: creature.id
        x: tile.x
        y: tile.y
        z: tile.z
        hp: creature.hp
        hp_max: creature.hp
        created: now
        last_action: now
      db.characters.insert character, cb
    (character, cb) ->
      query =
        _id: tile._id
      update =
        $push:
          people:
            _id: character._id
            creature: creature.id
            hp: character.hp
            hp_max: character.hp_max
      db.tiles.update query, update, cb
  ], cb
