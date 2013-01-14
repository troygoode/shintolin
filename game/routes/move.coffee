commands = require '../../commands'

module.exports = (app) ->
  app.post '/move/:direction', (req, res, next) ->
    commands.move req.character, req.param('direction'), (err) ->
      return next(err) if err?
      res.redirect '/game'
