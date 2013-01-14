commands = require '../../commands'

module.exports = (app) ->
  app.post '/chat', (req, res, next) ->
    commands.say req.character, req.body.text, (err) ->
      return next(err) if err?
      res.redirect '/game'
