bcrypt = require 'bcrypt'
db = require '../db'
get_character_by_name = require './get_character_by_name'

module.exports = (name, password, cb) ->
  get_character_by_name name, (err, character) ->
    return cb(err) if err?
    return cb(null, false) unless character?
    bcrypt.compare password, character.password, (err, ok) ->
      return cb(err) if err?
      cb null, ok, character
