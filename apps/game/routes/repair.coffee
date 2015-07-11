_ = require 'underscore'
async = require 'async'
mw = require '../middleware'
data = require '../../../data'
commands = require '../../../commands'

module.exports = (app) ->
  app.post '/repair', mw.not_dazed, (req, res, next) ->
    return next('You cannot repair a tile without a building.') unless req.tile.building?
    building = data.buildings[req.tile.building]
    return next('You cannot repair this kind of building.') unless building?.repair?

    commands.craft req.character, req.tile, building, 'repair', (err, io, broken_items) ->
      return next(err) if err?
      return next('You cannot repair this building right now.') unless io?
      async.parallel [
        (cb) ->
          commands.send_message 'repair', req.character, req.character,
            building: building.id
            gives: io.gives
            takes: io.takes
            broken: broken_items
          , cb
        (cb) ->
          commands.send_message_nearby 'repair_nearby', req.character, [req.character],
            building: building.id
            gives: io.gives
            takes: io.takes
            broken: broken_items
          , cb
      ], (err) ->
        return next(err) if err?
        res.redirect '/game'
