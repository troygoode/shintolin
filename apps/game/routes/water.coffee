async = require 'async'
_ = require 'underscore'
commands = require '../../../commands'
data = require '../../../data'
mw = require '../middleware'

module.exports = (app) ->
  app.post '/water', mw.not_dazed, mw.available_actions('water'), (req, res, next) ->
    return next('Invalid Item') unless req.item?
    return next('Invalid Item') unless _.contains req.item.tags, 'water'

    async.series [
      (cb) ->
        growth = parseInt(((req.tile.hp + 1) / 3) + 4)
        if req.tile.hp + growth > 200
          growth = 200 - req.tile.hp
        recipe =
          takes:
            ap: 1
            season: ['spring', 'summer']
            items: {}
          gives:
            tile_hp: growth
            xp:
              herbalist: 3
        recipe.takes.items[req.item.id] = 1
        commands.craft req.character, req.tile, recipe, null, cb
      (cb) ->
        commands.water_field req.tile, cb
      (cb) ->
        commands.send_message 'water', req.character, req.character, null, cb
    ], (err) ->
      return next(err) if err?
      res.redirect '/game'
