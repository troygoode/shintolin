_ = require 'underscore'
async = require 'async'
mw = require '../middleware'
data = require '../../../data'
commands = require '../../../commands'
QUARRY_CHANCE = .5

module.exports = (app) ->
  app.post '/quarry', mw.not_dazed, mw.available_actions('quarry'), (req, res, next) ->
    tool = _.find req.character.items, (i) ->
      _.contains data.items[i.item].tags, 'quarry'
    return next('You need a pick to quarry here.') unless tool?.count > 0
    item = data.items[tool.item]

    recipe =
      takes:
        tools: [item.id]
        skill: 'quarrying'
        ap: 4
    if Math.random() < QUARRY_CHANCE
      recipe.gives =
        items:
          boulder: 1
        xp:
          crafter: 3
    commands.craft req.character, req.tile, recipe, null, (err, recipe, broken_items) ->
      return next(err) if err?
      commands.send_message 'quarry', req.character, req.character,
        success: recipe.gives?
        tool: item.id
        broken: broken_items?.length > 0
      , (err) ->
        return next(err) if err?
        res.redirect '/game'
