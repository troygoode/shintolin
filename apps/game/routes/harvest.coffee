async = require 'async'
_ = require 'underscore'
commands = require '../../../commands'
data = require '../../../data'
time = require '../../../time'
mw = require '../middleware'

module.exports = (app) ->
  app.post '/harvest', mw.not_dazed, (req, res, next) ->
    return next('Invalid Item') unless req.item?
    return next('That item cannot be used to harvest crops.') unless _.contains req.item.tags, 'harvest'

    ap = 16
    ap = 8 if _.contains req.item.tags, 'harvest+'
    return next('Insufficient AP') unless req.character.ap >= ap
    return next('You must have the skill agriculture to do that.') unless _.contains req.character.skills, 'agriculture'

    season = time().season
    return next('You must wait until autumn before crops can be harvested.') unless season is 'Autumn'

    harvest_size = 10
    if harvest_size > req.tile.hp
      harvest_size = req.tile.hp

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
        if _.contains actions, 'harvest'
          cb()
        else
          cb('There is nothing to harvest here.')
      (cb) ->
        io =
          takes:
            ap: ap
            tools: [req.item.id]
            tile_hp: harvest_size
          gives:
            items:
              wheat: harvest_size
            xp:
              herbalist: 4
        commands.craft req.character, req.tile, io, null, cb
      (cb) ->
        return cb() if harvest_size < req.tile.hp
        commands.remove_building req.tile, cb
      (cb) ->
        commands.send_message 'harvest', req.character, req.character,
          amount: harvest_size
          remaining: req.tile.hp - harvest_size
        , cb
    ], (err) ->
      return next(err) if err?
      res.redirect '/game'
