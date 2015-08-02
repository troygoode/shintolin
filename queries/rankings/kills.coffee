moment = require 'moment'
db = require '../../db'

db.register_index db.characters,
  creature: 1
  kills: -1

module.exports = (cb) ->
  query =
    creature: {$exists: false}
    kills: {$gt: 0}
    last_action:
      $gt: moment().subtract(24, 'hours')._d
  db.characters.find(query).sort({ kills: -1, frags: -1, deaths: 1, created: 1 }).limit(10).toArray cb
