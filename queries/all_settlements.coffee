db = require '../db'

db.register_index db.settlements,
  name: 1

module.exports = (cb) ->
  db.settlements().find({}).sort(name: 1).toArray cb
