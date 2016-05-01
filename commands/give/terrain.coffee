_ = require 'underscore'
async = require 'async'
db = require '../../db'
data = require '../../data'

module.exports = (character, tile, msg) ->
  # change tile terrain
  return unless msg?.length and msg isnt tile.terrain
  QUERY =
    _id: tile._id
  UPDATE =
    $set:
      terrain: msg
  db.tiles().updateOne QUERY, UPDATE
