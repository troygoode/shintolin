db = require '../../db'

db.register_index db.characters,
  creature: 1
  revives: -1

module.exports = (cb) ->
  query =
    creature: {$exists: false}
  db.characters.find(query).sort({ revives: -1 }).toArray cb
