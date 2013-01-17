db = require '../db'
queries = require '../queries'

module.exports = (character, ap, cb) ->
  if ap > character.ap
    cb 'Unsufficient Action Points'
  else
    query =
      _id: character._id
    update =
      $inc:
        ap: 0 - ap
    db.characters.update query, update, cb
