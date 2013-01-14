db = require '../../db'

db.register_index db.characters,
  created: 1

module.exports = (cb) ->
  db.characters.find().sort({ created: 1 }).toArray cb
