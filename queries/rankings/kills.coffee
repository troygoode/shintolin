db = require '../../db'

db.register_index db.characters,
  creature: 1
  kills: -1

module.exports = (cb) ->
  query =
    creature: {$exists: false}
  db.characters.find(query).sort({ kills: -1 }).toArray cb
