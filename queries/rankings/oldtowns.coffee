db = require '../../db'

db.register_index db.settlements,
  founded: 1

module.exports = (cb) ->
  db.settlements().find().sort({ founded: 1 }).limit(10).toArray cb
