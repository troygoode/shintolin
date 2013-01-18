commands = require '../../commands'

#TODO: skill-check
module.exports = (app) ->
  app.post '/paint', (req, res, next) ->
    commands.paint req.tile, req.body.terrain, (err) ->
      return next(err) if err?
      res.redirect '/game'
