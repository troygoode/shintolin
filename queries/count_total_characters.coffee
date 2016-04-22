moment = require 'moment'
db = require '../db'

db.register_index db.characters,
  slug: 1

module.exports = (cb) ->
  query =
    slug:
      $exists: true
  db.characters().find(query).count cb
