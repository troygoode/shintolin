_ = require 'underscore'
async = require 'async'
db = require '../../db'
data = require '../../data'

module.exports = (character, tile, msg) ->
  QUERY =
    _id: character._id
  UPDATE =
    $inc:
      xp_wanderer: msg.wanderer ? 0
      xp_herbalist: msg.herbalist ? 0
      xp_crafter: msg.crafter ? 0
      xp_warrior: msg.warrior ? 0
  db.characters().updateOne QUERY, UPDATE
