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
    query =
      _id: ctx.tile._id
    update =
      $unset:
        building: true
        hp: true
    db.tiles.update query, update, cb

remove_interior = (ctx) ->
  (cb) ->
    return cb() unless ctx.building.interior?
    async.parallel [
      (cb) ->
        query =
          x: ctx.tile.x
          y: ctx.tile.y
          z: 1
        db.tiles.remove query, cb
      , (cb) ->
        query =
          x: ctx.tile.x
          y: ctx.tile.y
          z: 1
        update =
          $set:
            x: ctx.tile.x
            y: ctx.tile.y
            z: 0
        db.characters.update query, update, false, true, cb
    ], cb

remove_settlement = (ctx) ->
  (cb) ->
    return cb() unless ctx.settlement? and ctx.building.id is 'totem'
    async.parallel [
      (cb) ->
        query =
          _id: settlement._id
        db.settlements.remove query, cb
      , (cb) ->
        query =
          settlement_id: settlement._id
        update =
          $unset:
            settlement_id: true
            settlement_name: true
            settlement_slug: true
            settlement_joined: true
            settlement_provisional: true
        db.characters.update query, update, false, true, cb
    ], cb

notify_interior = (ctx) ->
  (cb) ->
    return cb() unless ctx.building.interior?
    coords =
      x: ctx.tile.x
      y: ctx.tile.y
      z: 1
    send_message_tile 'demolish_inside', null, coords, [], format_message ctx, cb

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
