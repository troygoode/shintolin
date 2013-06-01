_ = require 'underscore'
async = require 'async'
data = require '../data'
db = require '../db'
teleport = require './teleport'

module.exports = (creature, tile, cb) ->
  now = new Date()
  async.waterfall [
    (cb) ->
      character =
        creature: creature.id
        x: tile.x
        y: tile.y
        z: tile.z
        region: tile.region
        hp: creature.hp
        hp_max: creature.hp
        created: now
        last_action: now
      db.characters.insert character, cb
    (character, cb) ->
      teleport character, undefined, tile, cb
  ], cb
