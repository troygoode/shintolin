db = require '../../db'

db.register_index db.settlements,
  population: -1

module.exports = (cb) ->
  db.settlements.find().sort({ population: -1 }).toArray cb
