db = require '../../db'

db.register_index db.characters,
  creature: 1
  frags: -1

module.exports = (cb) ->
  query =
    creature: {$exists: false}
  db.characters.find(query).sort({ frags: -1 }).toArray cb
