db = require '../db'

module.exports = (cb) ->
  db.characters.find({}).toArray cb
