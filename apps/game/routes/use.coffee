commands = require '../../../commands'
mw = require '../middleware'

#TODO: implement

module.exports = (app) ->
  app.post '/use', mw.not_dazed, mw.ap(1), (req, res, next) ->
    res.redirect '/game'
