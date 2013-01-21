db = require '../db'

module.exports = (character, bio, image_url, cb) ->
  query =
    _id: character._id
  update =
    $set:
      bio: bio ? ''
      image_url: image_url ? ''
  db.characters.update query, update, cb
