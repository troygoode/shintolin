db = require '../../db'

db.register_index db.characters,
  last_revived: -1

module.exports = (cb) ->
  db.characters.find().sort({ last_revived: -1 }).toArray cb
