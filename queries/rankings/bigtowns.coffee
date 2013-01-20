db = require '../../db'

db.register_index db.settlements,
  member_counter: -1

module.exports = (cb) ->
  db.settlements.find().sort({ member_count: -1 }).toArray cb
