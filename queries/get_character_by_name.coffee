db = require '../db'

db.register_index db.characters,
  name: 1

module.exports = (name, cb) ->
  query =
    name: new RegExp("^#{name}$", 'i')
  db.characters().findOne query, cb
