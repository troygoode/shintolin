async = require 'async'
commands = require '../../../commands'
data = require '../../../data'
mw = require '../middleware'

module.exports = (app) ->
  app.post '/build', mw.not_dazed, (req, res, next) ->
    return next('You cannot build a building inside a building.') if req.tile.z isnt 0 #Xyzzy shenanigans!

    building = data.buildings[req.param('building')]
    return next('Invalid Building') unless building?
    return next('There is already a building here.') if req.tile.building? and not building.upgrade

    terrain = data.terrains[req.tile.terrain]
    return next('Nothing can be built here.') unless terrain.buildable?
    return next('You cannot build that here.') unless terrain.buildable.indexOf(building.size) isnt -1

    return building.build_handler(req, res, next) if building.build_handler?

    if req.tile.settlement_id? and (not req.character.settlement_id? or req.character.settlement_id.toString() isnt req.tile.settlement_id.toString() or req.character.settlement_provisional)
      return next('You must be a non-provisional member of this settlement to build here.')

    commands.craft req.character, req.tile, building, 'build', (err, io, broken_items) ->
      return next(err) if err?
      async.series [
        (cb) ->
          commands.create_building req.tile, building, cb
        (cb) ->
          commands.send_message 'built', req.character, req.character,
            building: building.id
            gives: io.gives
            takes: io.takes
            broken: broken_items
          , cb
        (cb) ->
          commands.send_message_nearby 'built_nearby', req.character, [req.character],
            building: building.id
            gives: io.gives
            takes: io.takes
            broken: broken_items
          , cb
      ], (err) ->
        return next(err) if err?
        res.redirect '/game'
