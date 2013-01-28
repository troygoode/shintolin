async = require 'async'
db = require '../db'
data = require '../data'
queries = require '../queries'
send_message_coords = require './send_message_coords'
send_message_settlement = require './send_message_settlement'
teleport = require './teleport'

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
        hq: true
    db.tiles.update query, update, cb

remove_interior = (ctx) ->
  (cb) ->
    return cb() unless ctx.building.interior?
    async.series [
      (cb) ->
        old_coords =
          x: ctx.tile.x
          y: ctx.tile.y
          z: 1
        new_coords =
          x: ctx.tile.x
          y: ctx.tile.y
          z: 0
        db.characters.find(old_coords).toArray (err, characters) ->
          return cb(err) if err?
          async.forEach characters, (character, cb) ->
            teleport character, old_coords, new_coords, cb
          , cb
      , (cb) ->
        query =
          x: ctx.tile.x
          y: ctx.tile.y
          z: 1
        db.tiles.remove query, cb
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
      , (cb) ->
        query =
          settlement_id: settlement._id
        update =
          $unset:
            settlement_id: true
            settlement_name: true
            settlement_slug: true
        db.tiles.update query, update, false, true, cb
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
    return cb() unless ctx.settlement? and ctx.building.id is 'totem'
    msg =
      settlement_name: ctx.settlement.name
      destroyer_id: ctx.destroyer?._id
      destroyer_name: ctx.destroyer?.name
      destroyer_slug: ctx.destroyer?.slug
    send_message_settlement 'settlement_destroyed', null, ctx.settlement, [], msg, cb

module.exports = (destroyer, tile, cb) ->
  return cb() unless tile.building?
  context =
    destroyer: destroyer
    tile: tile
    building: data.buildings[tile.building]

  actions = []
  actions.push get_settlement
  actions.push notify_nearby
  actions.push notify_interior
  actions.push notify_settlement
  actions.push remove_building
  actions.push remove_interior
  actions.push remove_settlement
  async.series actions.map((a) ->
    a context
  ), cb
