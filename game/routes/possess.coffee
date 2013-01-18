mw = require '../middleware'

module.exports = (app) ->
  app.post '/possess', (req, res, next) ->
    return next('Invalid target.') unless req.target?
    req.session.character = req.target._id.toString()
    req.session.email = req.target.email
    res.redirect '/game'
