db = require '../db'

db.register_index db.characters,
  name: 1

module.exports = (cb) ->
  db.characters.find({}).sort(name: 1).toArray cb
