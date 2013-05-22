_ = require 'underscore'
mw = require '../middleware'
data = require '../../../data'
commands = require '../../../commands'

module.exports = (app) ->
  app.post '/craft', mw.not_dazed, (req, res, next) ->
    recipe = data.recipes[req.param('recipe')]
    return next('Invalid recipe') unless recipe?.craft?

    commands.craft req.character, req.tile, recipe.craft, (err, io, broken_items) ->
      return next(err) if err?
      commands.send_message 'craft', req.character, req.character,
        recipe: recipe.name
        gives: io.gives
        takes: io.takes
        broken: broken_items
      , (err) ->
        return next(err) if err?
        res.redirect '/game'
