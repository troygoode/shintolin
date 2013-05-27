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
        building = data.buildings[req.tile.building] if req.tile.building?
        actions = []
        if terrain.actions? and _.isFunction terrain.actions
          actions = _.union actions, terrain.actions(req.character, req.tile)
        else if terrain.actions?
          actions = _.union actions, terrain.actions
        if building?.actions? and _.isFunction building.actions
          actions = _.union actions, building.actions(req.character, req.tile)
        else if building?.actions?
          actions = _.union actions, building.actions
        if _.contains actions, 'fill'
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
        commands.add_item req.character, data.items.pot_water, 1, cb
      (cb) ->
        commands.send_message 'fill', req.character, req.character, null, cb
    ], (err) ->
      return next(err) if err?
      res.redirect '/game'
