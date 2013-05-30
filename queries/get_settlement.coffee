db = require '../db'

module.exports = (id, cb) ->
  return cb() unless id?
  _id = db.ObjectId(id)
  query =
    _id: _id
  db.settlements.findOne query, cb
