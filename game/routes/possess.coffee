mw = require '../middleware'

module.exports = (app) ->
  app.post '/possess', (req, res, next) ->
    return next('Invalid target.') unless req.target?
    return next('Cannot possess a building.') if req.target is 'building'
    req.session.character = req.target._id.toString()
    req.session.email = req.target.email
    res.redirect '/game'
