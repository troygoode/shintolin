moment = require 'moment'
db = require '../../db'

db.register_index db.characters,
  last_action: -1
  creature: 1

module.exports = (cb) ->
  query =
    creature: {$exists: false}
    last_action:
      $lte: moment().subtract(5, 'days')._d
  db.characters.find(query).sort({ last_action: -1 }).toArray cb
