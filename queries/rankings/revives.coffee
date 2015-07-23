db = require '../../db'

db.register_index db.characters,
  creature: 1
  revives: -1

module.exports = (cb) ->
  query =
    creature: {$exists: false}
    revives: {$gt: 0}
  db.characters.find(query).sort({ revives: -1, frags: -1, created: 1 }).limit(10).toArray cb
