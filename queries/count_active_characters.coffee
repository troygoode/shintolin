moment = require 'moment'
db = require '../db'

db.register_index db.characters,
  last_action: -1
  slug: 1

module.exports = (cb) ->
  query =
    last_action:
      $gt: moment().subtract(24, 'hours')._d
    slug:
      $exists: true
  db.characters.find(query).count cb
