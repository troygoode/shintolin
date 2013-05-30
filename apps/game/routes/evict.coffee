_ = require 'underscore'
async = require 'async'
mw = require '../middleware'
commands = require '../../../commands'

module.exports = (app) ->
  app.post '/evict', mw.not_dazed, mw.available_actions('evict'), mw.settlement, (req, res, next) ->
    return next('Invalid Target') unless req.target?
    return next('You must be the settlement leader to do that.') unless req.settlement.leader?._id?.toString() is req.character._id.toString()
    commands.evict req.target, (err) ->
      return next(err) if err?
      res.redirect '/game'
