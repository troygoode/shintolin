db = require '../../db'

db.register_index db.characters,
  revives: -1

module.exports = (cb) ->
  db.characters.find().sort({ revives: -1 }).toArray cb
