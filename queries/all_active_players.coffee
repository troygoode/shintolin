moment = require 'moment'
db = require '../db'

db.register_index db.characters,
  email: 1
  last_action: -1

module.exports = (cb) ->
  query =
    email:
      $exists: true
    last_action:
      $gt: moment().subtract(24, 'hours')._d

  db.characters.find(query).sort(last_action: -1).toArray cb
