moment = require 'moment'
db = require '../../db'

db.register_index db.characters,
  creature: 1
  last_revived: 1

module.exports = (cb) ->
  query =
    creature: {$exists: false}
    hp: {$gt: 0}
  db.characters().find(query).sort({
    last_revived: 1
    created: 1
  }).limit(10).toArray cb
