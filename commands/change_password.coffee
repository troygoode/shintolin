async = require 'async'
db = require '../db'
hash_password = require './hash_password'

module.exports = (character, password, cb) ->
  query =
    _id: character._id
  update =
    $set:
      password: hash_password(password)

  db.characters.update query, update, cb
