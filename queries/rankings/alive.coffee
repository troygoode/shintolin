moment = require 'moment'
db = require '../../db'

module.exports = (cb) ->
  query =
    creature: {$exists: false}
    hp: {$gt: 0}
  db.characters().find(query).sort({ hp: -1, ap: -1 }).toArray cb
