moment = require 'moment'
db = require '../db'

db.register_index db.characters,
  last_action: -1
  slug: 1

module.exports = (cb) ->
  query =
    last_action:
      $gt: moment().subtract(5, 'days')._d
    $or: [
      { banned: { $exists: false } }
      { banned: false }
    ]
    slug:
      $exists: true
  db.characters().find(query).count cb
