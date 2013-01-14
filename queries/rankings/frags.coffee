db = require '../../db'

db.register_index db.characters,
  frags: -1

module.exports = (cb) ->
  db.characters.find().sort({ frags: -1 }).toArray cb
