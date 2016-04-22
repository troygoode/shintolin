_ = require 'underscore'
async = require 'async'
db = require '../../db'
data = require '../../data'

module.exports = (character, tile, msg, cb) ->
  # change tile terrain
  return cb() unless msg?.length and msg isnt tile.terrain
  query =
    _id: tile._id
  update =
    $set:
      terrain: msg
  db.tiles().updateOne query, update, cb
