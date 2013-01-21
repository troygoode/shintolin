commands = require '../../commands'
queries = require '../../queries'

module.exports = (app) ->
  app.post '/leave', (req, res, next) ->
    res.redirect '/game'
