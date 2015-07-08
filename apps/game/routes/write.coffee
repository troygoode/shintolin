_ = require 'underscore'
async = require 'async'
mw = require '../middleware'
data = require '../../../data'
commands = require '../../../commands'

module.exports = (app) ->
  app.post '/write', mw.not_dazed, mw.available_actions('write'), mw.ap(3), (req, res, next) ->
    return next('You don\'t have anything to write with.') unless _.some req.character.items ? [], (item) ->
      type = data.items[item.item]
      item.count >= 1 and _.contains type.tags ? [], 'write'

    message = req.body.message
    async.series [
      (cb) ->
        commands.write req.character, req.tile, message, cb
      (cb) ->
        msg =
          message: message
          building: req.tile.building
          outside: req.tile.z is 0
        commands.send_message 'write', req.character, req.character, msg, cb
      (cb) ->
        msg =
          message: message
          building: req.tile.building
          outside: req.tile.z is 0
        commands.send_message_nearby 'write_nearby', req.character, [req.character], msg, cb
    ], (err) ->
      return next(err) if err?
      res.redirect '/game'
