_ = require 'underscore'
async = require 'async'
mw = require '../middleware'
data = require '../../../data'
commands = require '../../../commands'

module.exports = (app) ->
  app.post '/repair', mw.not_dazed, (req, res, next) ->
    commands.repair req.character, req.tile, (err) ->
      return cb('You cannot repair a tile without a building.') unless tile.building?
      building = data.buildings[tile.building]
      return cb('You cannot repair this kind of building.') unless building?.repair?

      commands.craft req.character, req.tile, building.repair, (err, io, broken_items) ->
        return next(err) if err?
        return next('You cannot repair this building right now.') unless io?
        commands.send_message 'repair', req.character, req.character,
          building: req.tile.building
          gives: io.gives
          takes: io.takes
          broken: broken_items
        , (err) ->
          return next(err) if err?
          res.redirect '/game'
