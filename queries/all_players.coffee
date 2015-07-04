db = require '../db'

db.register_index db.characters,
  name: 1
  email: 1

module.exports = (cb) ->
  db.characters.find(email: {$exists: true}).sort(name: 1).toArray cb
