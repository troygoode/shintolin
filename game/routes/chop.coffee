async = require 'async'
mw = require '../middleware'
data = require '../../data'
commands = require '../../commands'

module.exports = (app) ->
  app.post '/chop', mw.not_dazed, (req, res, next) ->
    return next('There are no trees to chop here.') unless data.terrains[req.tile.terrain].chop
    async.series [
      (cb) ->
        commands.charge_ap req.character, 8, cb
      , (cb) ->
        commands.xp req.character, 2, 0, 0, 0, cb
      , (cb) ->
        commands.add_item req.character, data.items.log, 1, cb
      , (cb) ->
        commands.send_message 'chop', req.character, req.character, {}, cb
    ], (err) ->
      return next(err) if err?
      res.redirect '/game'
