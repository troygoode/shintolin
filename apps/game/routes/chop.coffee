_ = require 'underscore'
async = require 'async'
mw = require '../middleware'
data = require '../../../data'
chop = data.actions.chop
commands = require '../../../commands'
SHRINK_ODDS = .12

module.exports = (app) ->
  app.post '/chop', mw.not_dazed, mw.available_actions('chop'), (req, res, next) ->
    tool = _.find req.character.items, (i) ->
      _.contains data.items[i.item].tags, 'chop'
    return next('You have nothing to chop down a tree with.') unless tool?.count > 0
    item = data.items[tool.item]

    terrain = data.terrains[req.tile.terrain]

    recipe =
      takes:
        tools: [item.id]
        ap: chop.ap req.character, req.tile
      gives:
        items:
          log: 1
        xp:
          wanderer: 2

    if terrain.shrink? and Math.random() < SHRINK_ODDS
      recipe.gives.terrain = terrain.shrink(req.tile)

    commands.craft req.character, req.tile, recipe, null, (err, recipe, broken_items) ->
      return next(err) if err?
      commands.send_message 'chop', req.character, req.character,
        tool: item.id
        broken: broken_items?.length > 0
        shrank: new_terrain?
      , (err) ->
        return next(err) if err?
        res.redirect '/game'
