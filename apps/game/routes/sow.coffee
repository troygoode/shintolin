async = require 'async'
_ = require 'underscore'
commands = require '../../../commands'
data = require '../../../data'
time = require '../../../time'
mw = require '../middleware'

module.exports = (app) ->
  app.post '/sow', mw.not_dazed, (req, res, next) ->
    item = data.items[req.param('item')]
    return next('Invalid Item') unless item?

    return next('Insufficient AP') unless req.character.ap >= 15
    return next('You must have the skill agriculture to do that.') unless _.contains req.character.skills, 'agriculture'

    season = time().season
    return next('Crops can only be planted in the spring.') unless season is 'Spring'

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
        if _.contains actions, 'sow'
          cb()
        else
          cb('You cannot plant anything here.')
      (cb) ->
        return cb('You cannot plant that.') unless _.contains(item.tags, 'plantable')
        commands.remove_item req.character, item, 10, cb
      (cb) ->
        commands.charge_ap req.character, 15, cb
      (cb) ->
        gives =
          tile_hp: 10
        commands.give req.character, req.tile, gives, cb
      (cb) ->
        commands.xp req.character, 0, 5, 0, 0, cb
      (cb) ->
        commands.send_message 'sow', req.character, req.character, null, cb
    ], (err) ->
      return next(err) if err?
      res.redirect '/game'
