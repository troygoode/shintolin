async = require 'async'
_ = require 'underscore'
commands = require '../../../commands'
data = require '../../../data'
time = require '../../../time'
mw = require '../middleware'

module.exports = (app) ->
  app.post '/water', mw.not_dazed, (req, res, next) ->
    return next('Invalid Item') unless req.item?

    return next('Insufficient AP') unless req.character.ap >= 1

    season = time().season
    return next('You don\t need to water at this time of year.') unless season is 'Spring' or season is 'Summer'

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
        if _.contains actions, 'water'
          cb()
        else
          cb('You cannot water anything here.')
      (cb) ->
        commands.remove_item req.character, req.item, 1, cb
      (cb) ->
        commands.charge_ap req.character, 1, cb
      (cb) ->
        commands.water_field req.tile, cb
      (cb) ->
        gives =
          tile_hp: 5
        commands.give req.character, req.tile, gives, cb
      (cb) ->
        commands.xp req.character, 0, 3, 0, 0, cb
      (cb) ->
        commands.send_message 'water', req.character, req.character, null, cb
    ], (err) ->
      return next(err) if err?
      res.redirect '/game'
