async = require 'async'
db = require '../db'
queries = require '../queries'

get_settlement = (ctx) ->
  (cb) ->
    queries.get_settlement ctx.tile.settlement_id, (err, settlement) ->
      return cb(err) if err?
      ctx.settlement = settlement
      cb()

remove_building = (ctx) ->
  (cb) ->
    cb()

remove_interior = (ctx) ->
  (cb) ->
    return cb() unless ctx.building.interior?
    cb()

notify_interior = (ctx) ->
  (cb) ->
    return cb() unless ctx.building.interior?
    cb()

remove_settlement = (ctx) ->
  (cb) ->
    return cb() unless ctx.settlement? and ctx.building.id is 'totem'
    cb()

notify_settlement = (ctx) ->
  (cb) ->
    return cb() unless ctx.settlement? and ctx.building.id is 'totem'
    cb()

module.exports = (tile, cb) ->
  return cb() unless tile.building?
  context =
    tile: tile
    building: data.buildings[tile.building]

  actions = []
  actions.push get_settlement
  actions.push notify_interior
  actions.push notify_settlement
  actions.push remove_building
  actions.push remove_interior
  actions.push remove_settlement
  async.series actions.map (a) ->
    a context
  , cb
