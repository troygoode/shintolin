db = require '../db'

db.register_index db.characters,
  email: 1

module.exports = (email, cb) ->
  query =
    email: new RegExp("^#{email}$", 'i')
  db.characters().findOne query, cb
