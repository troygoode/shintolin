_ = require 'underscore'
debug =
  Base: require('debug')
  request: require('debug')('shintolin:request')

module.exports = (key, message) ->
  _debug = debug.Base(key)
  unless _.isFunction message
    _message = message
    message = ->
      _message
  (req, res, next) ->
    _debug message(req)
    next()

module.exports.request = (req, res, next) ->
  ticks = new Date().getTime()
  debug.request "enter #{req.url} (#{new Date().getTime()})"
  res.on 'finish', ->
    elapsed = (new Date().getTime()) - ticks
    debug.request "exit #{req.url} (#{new Date().getTime()}) (+#{elapsed}ms)"
  next()
