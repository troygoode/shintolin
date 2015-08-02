moment = require 'moment'
db = require '../../db'

db.register_index db.characters,
  creature: 1
  created: 1

module.exports = (cb) ->
  query =
    creature: {$exists: false}
    last_action:
      $gt: moment().subtract(24, 'hours')._d
  db.characters.find(query).sort({ created: 1 }).limit(10).toArray cb
