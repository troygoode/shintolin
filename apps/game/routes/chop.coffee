_ = require 'underscore'
async = require 'async'
mw = require '../middleware'
data = require '../../../data'
commands = require '../../../commands'

module.exports = (app) ->
  app.post '/chop', mw.not_dazed, mw.available_actions('chop'), (req, res, next) ->
    tool = _.find req.character.items, (i) ->
      _.contains data.items[i.item].tags, 'chop'
    return next('You have nothing to chop down a tree with.') unless tool?.count > 0
    item = data.items[tool.item]

    recipe =
      takes:
        tools: [item.id]
        ap: if _.contains(req.character.skills, 'lumberjack') then 4 else 8
      gives:
        items:
          log: 1
        xp:
          wanderer: 2
    commands.craft req.character, req.tile, recipe, null, (err, recipe, broken_items) ->
      return next(err) if err?
      commands.send_message 'chop', req.character, req.character,
        tool: item.id
        broken: broken_items?.length > 0
      , (err) ->
        return next(err) if err?
        res.redirect '/game'
