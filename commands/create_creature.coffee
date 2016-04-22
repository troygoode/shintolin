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
      db.characters().insertOne character, cb
    (response, cb) ->
      creature = response.ops[0]
      teleport creature, undefined, tile, cb
  ], cb
