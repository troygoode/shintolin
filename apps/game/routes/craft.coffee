_ = require 'underscore'
mw = require '../middleware'
data = require '../../../data'
commands = require '../../../commands'

module.exports = (app) ->
  app.post '/craft', mw.not_dazed, (req, res, next) ->
    recipe = data.recipes[req.param('recipe')]
    return next('Invalid recipe') unless recipe?

    commands.craft req.character, req.tile, recipe, (err) ->
      return next(err) if err?
      res.redirect '/game'
