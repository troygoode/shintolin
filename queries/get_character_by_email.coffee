db = require '../db'

db.register_index db.characters,
  email: 1

module.exports = (email, cb) ->
  query =
    email: new RegExp("^#{name}$", 'i')
  db.characters.findOne query, cb
