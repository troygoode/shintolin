db = require '../../db'

db.register_index db.characters,
  creature: 1
  created: 1

module.exports = (cb) ->
  query =
    creature: {$exists: false}
  db.characters.find(query).sort({ created: 1 }).limit(10).toArray cb
