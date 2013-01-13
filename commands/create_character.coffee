db = require '../db'

module.exports = (character, cb) ->
  db.characters.insert character, cb
