moment = require 'moment'
db = require '../db'

db.register_index db.characters,
  email: 1
  last_action: -1

module.exports = (cb) ->
  query =
    email:
      $exists: true
    $or: [
      {
        last_action: { $gt: moment().subtract(5, 'days')._d }
      }
      {
        hp: {$gt: 0}
      }
    ]

  db.characters().find(query).sort(last_action: -1, hp: 1).toArray cb
