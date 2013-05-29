_ = require 'underscore'
mw = require '../middleware'
commands = require '../../../commands'

module.exports = (app) ->
  app.post '/drop', (req, res, next) ->
    return res.redirect '/game' unless req.item?
    count = req.param('count') ? 1
    commands.remove_item req.character, req.item, count, (err) ->
      return next(err) if err?
      msg =
        quantity: count
        item: req.item.id
      commands.send_message 'drop', req.character, req.character, msg, (err) ->
        return next(err) if err?
        res.redirect '/game'
