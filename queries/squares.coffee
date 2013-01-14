db = require '../db'

module.exports = (cb) ->
  db.tiles.find().count cb
