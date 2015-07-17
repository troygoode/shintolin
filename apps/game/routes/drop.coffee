_ = require 'underscore'
async = require 'async'
mw = require '../middleware'
commands = require '../../../commands'

module.exports = (app) ->
  app.post '/drop', (req, res, next) ->
    return res.redirect '/game' unless req.item?
    count = parseInt(req.body.count ? 1)

    async.series [
      (cb) ->
        commands.remove_item req.character, req.item, count, cb
      (cb) ->
        commands.give.items null, req.tile, {item: req.item, count: count}, cb
      (cb) ->
        commands.send_message 'drop', req.character, req.character, {item: req.item.id, quantity: count}, cb
    ], (err) ->
      return next(err) if err?
      res.redirect '/game'
