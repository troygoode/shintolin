commands = require '../../../commands'
data = require '../../../data'
MAX_WEIGHT = 70

module.exports = (app) ->
  app.post '/move/enter', (req, res, next) ->
    return next('You are over-encumbered and cannot move.') unless req.character.weight <= MAX_WEIGHT
    building = data.buildings[req.tile.building]
    return next('Invalid Direction') unless building?.interior?
    commands.move req.character, 'enter', (err) ->
      return next(err) if err?
      if req.body?.redirect is 'map'
        res.redirect '/game/map'
      else
        res.redirect '/game'

  app.post '/move/exit', (req, res, next) ->
    return next('You are over-encumbered and cannot move.') unless req.character.weight <= MAX_WEIGHT
    return next('Invalid Direction') unless req.tile.z is 1
    commands.move req.character, 'exit', (err) ->
      return next(err) if err?
      if req.body?.redirect is 'map'
        res.redirect '/game/map'
      else
        res.redirect '/game'

  app.post '/move/:direction', (req, res, next) ->
    return next('You are over-encumbered and cannot move.') unless req.character.weight <= MAX_WEIGHT
    return next('Invalid Direction') unless req.tile.z is 0
    commands.move req.character, req.params.direction, (err) ->
      return next(err) if err?
      if req.body?.redirect is 'map'
        res.redirect '/game/map'
      else
        res.redirect '/game'
