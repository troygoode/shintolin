async = require 'async'
_ = require 'underscore'
commands = require '../../../commands'
data = require '../../../data'
mw = require '../middleware'

module.exports = (app) ->
  app.post '/sow', mw.not_dazed, mw.available_actions('sow'), (req, res, next) ->
    item = data.items[req.param('item')]
    return next('Invalid Item') unless item?
    return cb('You cannot plant that.') unless _.contains(item.tags, 'plantable')

    async.series [
      (cb) ->
        recipe =
          takes:
            ap: 15
            skill: 'agriculture'
            season: 'spring'
            items: {}
          gives:
            tile_hp: 1
            xp:
              herbalist: 5
        recipe.items[item.id] = 10
        commands.craft req.character, req.tile, recipe, null, cb
      (cb) ->
        commands.increase_overuse req.tile, 12, cb
      (cb) ->
        commands.send_message 'sow', req.character, req.character, null, cb
    ], (err) ->
      return next(err) if err?
      res.redirect '/game'
