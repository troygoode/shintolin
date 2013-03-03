_ = require 'underscore'
async = require 'async'
mw = require '../middleware'
data = require '../../../data'
commands = require '../../../commands'
chop_break_chance = .05

module.exports = (app) ->
  app.post '/chop', mw.not_dazed, (req, res, next) ->
    return next('There are no trees to chop here.') unless data.terrains[req.tile.terrain].chop
    tool = _.find req.character.items, (i) ->
      data.items[i.item].chop
    return next('You have nothing to chop down a tree with.') unless tool?.count > 0
    tool = data.items[tool.item]
    broken = Math.random() <= chop_break_chance
    async.series [
      (cb) ->
        commands.charge_ap req.character, 8, cb
      , (cb) ->
        commands.xp req.character, 2, 0, 0, 0, cb
      , (cb) ->
        commands.add_item req.character, data.items.log, 1, cb
      , (cb) ->
        return cb() unless broken
        commands.remove_item req.character, tool, 1, cb
      , (cb) ->
        commands.send_message 'chop', req.character, req.character,
          tool: tool.id
          broken: if broken then broken else undefined
        , cb
    ], (err) ->
      return next(err) if err?
      res.redirect '/game'
