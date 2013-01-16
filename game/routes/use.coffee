commands = require '../../commands'

module.exports = (app) ->
  app.post '/use', (req, res, next) ->
    res.redirect '/game'
