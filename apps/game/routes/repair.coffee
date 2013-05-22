_ = require 'underscore'
async = require 'async'
mw = require '../middleware'
data = require '../../../data'
commands = require '../../../commands'

module.exports = (app) ->
  app.post '/repair', mw.not_dazed, (req, res, next) ->
    commands.repair req.character, req.tile, (err) ->
      return next(err) if err?
      res.redirect '/game'
