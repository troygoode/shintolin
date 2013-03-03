commands = require '../../../commands'
data = require '../../../data'

module.exports = (app) ->
  app.post '/move/enter', (req, res, next) ->
    building = data.buildings[req.tile.building]
    return next('Invalid Direction') unless building?.interior?
    commands.move req.character, 'enter', (err) ->
      return next(err) if err?
      res.redirect '/game'

  app.post '/move/exit', (req, res, next) ->
    return next('Invalid Direction') unless req.tile.z is 1
    commands.move req.character, 'exit', (err) ->
      return next(err) if err?
      res.redirect '/game'

  app.post '/move/:direction', (req, res, next) ->
    return next('Invalid Direction') unless req.tile.z is 0
    commands.move req.character, req.param('direction'), (err) ->
      return next(err) if err?
      res.redirect '/game'
