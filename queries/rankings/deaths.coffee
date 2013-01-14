db = require '../../db'

db.register_index db.characters,
  deaths: -1

module.exports = (cb) ->
  db.characters.find().sort({ deaths: -1 }).toArray cb
