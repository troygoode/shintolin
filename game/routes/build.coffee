commands = require '../../commands'
data = require '../../data'
mw = require '../middleware'

module.exports = (app) ->
  app.post '/build', mw.not_dazed, (req, res, next) ->
    building = data.buildings[req.param('building')]
    return next('Invalid Building') unless building?
    return building.build(req, res, cb) if building.build?
    commands.build req.character, req.tile, building, (err) ->
      return next(err) if err?
      res.redirect '/game'
