async = require 'async'
_ = require 'underscore'
commands = require '../../../commands'
data = require '../../../data'
mw = require '../middleware'

module.exports = (app) ->
  app.post '/fill-pot', mw.not_dazed, mw.available_actions('fill'), (req, res, next) ->
    async.series [
      (cb) ->
        recipe =
          takes:
            ap: 1
            items:
              pot: 1
          gives:
            items:
              pot_water: 1
            xp:
              wanderer: 1
        commands.craft req.character, req.tile, recipe, null, cb
      (cb) ->
        commands.send_message 'fill', req.character, req.character, null, cb
    ], (err) ->
      return next(err) if err?
      res.redirect '/game'
