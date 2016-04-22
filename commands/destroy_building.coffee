async = require 'async'
db = require '../db'
data = require '../data'
queries = require '../queries'
send_message_coords = require './send_message_coords'
send_message_settlement = require './send_message_settlement'
teleport = require './teleport'
broadcast_message = require './broadcast_message'
_remove_building = require './remove_building'

db.register_index db.characters,
  settlement_id: 1
db.register_index db.tiles,
  settlement_id: 1

get_settlement = (ctx) ->
  (cb) ->
    queries.get_settlement ctx.tile.settlement_id?.toString(), (err, settlement) ->
      return cb(err) if err?
      ctx.settlement = settlement
      cb()

remove_building = (ctx) ->
  (cb) ->
    _remove_building ctx.tile, cb

remove_settlement = (ctx) ->
  (cb) ->
    return cb() unless ctx.settlement? and ctx.tile.hq
    async.parallel [
      (cb) ->
        query =
          _id: ctx.settlement._id
        update =
          $set:
            population: 0
            members: []
            destroyed: ctx.now
            destroyer:
              _id: ctx.destroyer?._id
              name: ctx.destroyer?.name
              slug: ctx.destroyer?.slug
          $unset:
            leader: true
        db.settlements().updateOne query, update, cb
      , (cb) ->
        query =
          settlement_id: ctx.settlement._id
        update =
          $unset:
            settlement_id: true
            settlement_name: true
            settlement_slug: true
            settlement_joined: true
            settlement_provisional: true
        db.characters().updateMany query, update, cb
      , (cb) ->
        query =
          settlement_id: ctx.settlement._id
        update =
          $unset:
            settlement_id: true
            settlement_name: true
            settlement_slug: true
        db.tiles().updateMany query, update, cb
    ], cb

notify_nearby = (ctx) ->
  (cb) ->
    coords =
      x: ctx.tile.x
      y: ctx.tile.y
      z: 0
    msg =
      building: ctx.building.id
      destroyer_id: ctx.destroyer?._id
      destroyer_name: ctx.destroyer?.name
      destroyer_slug: ctx.destroyer?.slug
    send_message_coords 'destroyed_nearby', null, coords, [], msg, cb

notify_interior = (ctx) ->
  (cb) ->
    return cb() unless ctx.building.interior?
    coords =
      x: ctx.tile.x
      y: ctx.tile.y
      z: 1
    msg =
      building: ctx.building.id
      destroyer_id: ctx.destroyer?._id
      destroyer_name: ctx.destroyer?.name
      destroyer_slug: ctx.destroyer?.slug
    send_message_coords 'destroyed_inside', null, coords, [], msg, cb

notify_settlement = (ctx) ->
  (cb) ->
    return cb() unless ctx.settlement? and not ctx.tile.hq
    msg =
      building: ctx.building.id
      settlement_id: ctx.settlement._id
      settlement_name: ctx.settlement.name
      settlement_slug: ctx.settlement.slug
      destroyer_id: ctx.destroyer?._id
      destroyer_name: ctx.destroyer?.name
      destroyer_slug: ctx.destroyer?.slug
    send_message_settlement 'destroyed_settlement_building', null, ctx.settlement, [], msg, cb

broadcast_settlement_destroyed = (ctx) ->
  (cb) ->
    return cb() unless ctx.settlement? and ctx.tile.hq
    broadcast_message 'settlement_removed', ctx.destroyer, [],
      settlement_id: ctx.settlement._id
      settlement_name: ctx.settlement.name
      settlement_slug: ctx.settlement.slug
      destroyer_id: ctx.destroyer?._id
      destroyer_name: ctx.destroyer?.name
      destroyer_slug: ctx.destroyer?.slug
    , cb

module.exports = (destroyer, tile, cb) ->
  return cb() unless tile.building?
  context =
    now: new Date()
    destroyer: destroyer
    tile: tile
    building: data.buildings[tile.building]

  actions = []
  actions.push get_settlement
  actions.push notify_nearby
  actions.push notify_interior
  actions.push notify_settlement
  actions.push broadcast_settlement_destroyed
  actions.push remove_building
  actions.push remove_settlement
  async.series actions.map((a) ->
    a context
  ), cb
