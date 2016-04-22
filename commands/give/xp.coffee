_ = require 'underscore'
async = require 'async'
db = require '../../db'
data = require '../../data'

module.exports = (character, tile, msg, cb) ->
  query =
    _id: character._id
  update =
    $inc:
      xp_wanderer: msg.wanderer ? 0
      xp_herbalist: msg.herbalist ? 0
      xp_crafter: msg.crafter ? 0
      xp_warrior: msg.warrior ? 0
  db.characters().updateOne query, update, cb
