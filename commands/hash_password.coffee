bcrypt = require 'bcrypt'

module.exports = (password) ->
  bcrypt.hashSync password, 12
