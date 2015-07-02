db = require '../db'
hash_password = require './hash_password'

module.exports = (character, bio, image_url, password, cb) ->
  query =
    _id: character._id
  update =
    $set:
      bio: bio ? ''
      image_url: image_url ? ''

  if password?.length
    update.$set.password = hash_password password

  db.characters.update query, update, cb
