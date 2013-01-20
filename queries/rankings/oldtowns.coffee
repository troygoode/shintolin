db = require '../../db'

db.register_index db.settlements,
  founded: 1

module.exports = (cb) ->
  db.settlements.find().sort({ revives: 1 }).toArray cb
