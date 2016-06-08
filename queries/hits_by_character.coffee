db = require '../db'

module.exports = (character) ->
  QUERY =
    character: character._id.toString()

  db.hits().find(QUERY).sort(last_access: -1).limit(120).toArray()
