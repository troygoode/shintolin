db = require '../../db'

db.register_index db.settlements,
  founded: 1

module.exports = (cb) ->
  db.settlements().find(favor: {$gte: 1}).sort({ favor: -1 }).limit(10).toArray cb
