commands = require '../../commands'
queries = require '../../queries'

module.exports = (app) ->
  app.post '/vote', (req, res, next) ->
    res.redirect '/game'
