commands = require '../../commands'
mw = require '../middleware'

module.exports = (app) ->
  app.post '/chat', mw.ap(1), (req, res, next) ->
    commands.say req.character, req.body.text, (err) ->
      return next(err) if err?
      res.redirect '/game'
