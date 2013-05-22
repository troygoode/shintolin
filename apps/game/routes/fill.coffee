async = require 'async'
_ = require 'underscore'
commands = require '../../../commands'
data = require '../../../data'
mw = require '../middleware'

module.exports = (app) ->
  app.post '/fill-pot', mw.not_dazed, mw.ap(1), (req, res, next) ->
    async.series [
      (cb) ->
        terrain = data.terrains[req.tile.terrain]
        if _.contains terrain.actions, 'fill'
          cb()
        else
          cb('You cannot fill a pot here.')
      (cb) ->
        if _.some req.character.items, ((i) -> i.item is 'pot' and i.count >= 1)
          cb()
        else
          cb('You don\'t have any container to fill with water.')
      (cb) ->
        commands.remove_item req.character, data.items.pot, 1, cb
      (cb) ->
        commands.add_item req.character, data.items.water_pot, 1, cb
      (cb) ->
        commands.send_message 'fill', req.character, req.character, null, cb
    ], (err) ->
      return next(err) if err?
      res.redirect '/game'
