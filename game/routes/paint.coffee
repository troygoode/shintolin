commands = require '../../commands'

module.exports = (app) ->
  app.post '/paint', (req, res, next) ->
    commands.paint req.character, req.body.terrain, (err) ->
      return next(err) if err?
      res.redirect '/game'
