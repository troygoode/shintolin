bcrypt = require 'bcrypt'
get_character_by_email = require './get_character_by_email'

module.exports = (email, password, cb) ->
  get_character_by_email email, (err, character) ->
    return cb(err) if err?
    return cb(null, false) unless character?
    bcrypt.compare password, character.password, (err, ok) ->
      return cb(err) if err?
      cb null, ok, character
