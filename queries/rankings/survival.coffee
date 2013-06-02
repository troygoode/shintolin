db = require '../../db'

db.register_index db.characters,
  creature: 1
  last_revived: 1

module.exports = (cb) ->
  query =
    creature: {$exists: false}
  db.characters.find(query).sort({ last_revived: 1 }).toArray cb
