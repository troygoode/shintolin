db = require '../../db'

db.register_index db.characters,
  kills: -1

module.exports = (cb) ->
  db.characters.find().sort({ kills: -1 }).toArray cb
