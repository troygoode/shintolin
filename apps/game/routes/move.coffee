commands = require '../../../commands'
data = require '../../../data'
MAX_WEIGHT = 70
last_move = {}
MIN_MOVE_GAP = 1000

move_middleware = (req, res, next) ->
  now = new Date().getTime()
  lm = last_move[req.character.name]
  if lm and (now - lm < MIN_MOVE_GAP)
    return next('You must wait before moving again.')
  else
    last_move[req.character.name] = now
    next()

module.exports = (app) ->
  app.post '/move/enter', move_middleware, (req, res, next) ->
    building = data.buildings[req.tile.building] if req.tile?.building?
    return next('Invalid Direction') unless building?.interior?
    commands.move req.character, 'enter', (err) ->
      return next(err) if err?
      if req.body?.redirect is 'map'
        res.redirect '/game/map'
      else
        res.redirect '/game'

  app.post '/move/exit', move_middleware, (req, res, next) ->
    return next('Invalid Direction') unless req.character.z is 1
    commands.move req.character, 'exit', (err) ->
      return next(err) if err?
      if req.body?.redirect is 'map'
        res.redirect '/game/map'
      else
        res.redirect '/game'

  app.post '/move/:direction', move_middleware, (req, res, next) ->
    return next('Invalid Direction') unless req.character.z is 0
    commands.move req.character, req.params.direction, (err) ->
      return next(err) if err?
      if req.body?.redirect is 'map'
        res.redirect '/game/map'
      else
        res.redirect '/game'
