moment = require 'moment'
db = require '../../db'

db.register_index db.characters,
  creature: 1
  created: -1

module.exports = (cb) ->
  query =
    creature: {$exists: false}
    $or: [
      {last_action: {$gt: moment().subtract(5, 'days')._d}}
      {hp: {$gt: 0}}
    ]
  db.characters().find(query).sort({ created: -1 }).limit(10).toArray cb
