db = require '../db'

module.exports = (id, cb) ->
  _id = new db.ObjectId(id)
  query =
    _id: _id
  db.settlements.findOne query, cb
