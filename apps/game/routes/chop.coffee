_ = require 'underscore'
async = require 'async'
mw = require '../middleware'
data = require '../../../data'
commands = require '../../../commands'
SHRINK_ODDS = .12

module.exports = (app) ->
  app.post '/chop', mw.not_dazed, mw.available_actions('chop'), (req, res, next) ->
    tool = _.find req.character.items, (i) ->
      _.contains data.items[i.item].tags, 'chop'
    return next('You have nothing to chop down a tree with.') unless tool?.count > 0
    item = data.items[tool.item]

    terrain = data.terrains[req.tile.terrain]
    if terrain.shrink? and Math.random() < SHRINK_ODDS
      new_terrain = terrain.shrink(req.tile)

    recipe =
      takes:
        tools: [item.id]
        ap: if _.contains(req.character.skills, 'lumberjack') then 4 else 8
      gives:
        terrain: new_terrain
        items:
          log: 1
        xp:
          wanderer: 2
    commands.craft req.character, req.tile, recipe, null, (err, recipe, broken_items) ->
      return next(err) if err?
      commands.send_message 'chop', req.character, req.character,
        tool: item.id
        broken: broken_items?.length > 0
        shrank: new_terrain?
      , (err) ->
        return next(err) if err?
        res.redirect '/game'
