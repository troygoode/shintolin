db = require '../db'

module.exports = (id, cb) ->
  _id = db.ObjectId(id)
  query =
    _id: _id
  db.characters().findOne query, cb
