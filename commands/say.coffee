db = require '../db'
send_message = require './send_message'

module.exports = (character, text, cb) ->
  send_message 'social', character, null,
    text: text
  , cb
