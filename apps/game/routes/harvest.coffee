async = require 'async'
_ = require 'underscore'
commands = require '../../../commands'
data = require '../../../data'
mw = require '../middleware'

module.exports = (app) ->
  app.post '/harvest', mw.not_dazed, mw.available_actions('harvest'), (req, res, next) ->
    return next('Invalid Item') unless req.item?
    return next('That item cannot be used to harvest crops.') unless _.contains req.item.tags, 'harvest'

    harvest_size = 10
    if harvest_size > req.tile.hp
      harvest_size = req.tile.hp

    async.series [
      (cb) ->
        recipe =
          takes:
            ap: if _.contains(req.item.tags, 'harvest+') then 8 else 16
            skill: 'agriculture'
            season: 'autumn'
            tools: [req.item.id]
            tile_hp: harvest_size
          gives:
            items:
              wheat: harvest_size
            xp:
              herbalist: 4
        commands.craft req.character, req.tile, recipe, null, cb
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
