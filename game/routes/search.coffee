_ = require 'underscore'
mw = require '../middleware'
commands = require '../../commands'

module.exports = (app) ->
  app.post '/search', mw.not_dazed, mw.ap(1), (req, res, next) ->
    item = 'wheat'
    commands.add_item req.character, item, 1, (err) ->
      return next(err) if err?
      res.redirect '/game'
