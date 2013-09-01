_ = require 'underscore'
Debug = require('debug')

module.exports = (key, message) ->
  debug = Debug(key)
  unless _.isFunction message
    _message = message
    message = ->
      _message
  (req, res, next) ->
    debug message(req)
    next()
