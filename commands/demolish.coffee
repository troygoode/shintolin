async = require 'async'
db = require '../db'
queries = require '../queries'
destroy_building = require './destroy_building'
send_message = require './send_message'
send_message_nearby = require './send_message_nearby'
send_message_settlement = require './send_message_settlement'
send_message_tile = require './send_message_tile'

format_msg = (ctx) ->
  if ctx.hit
    building: ctx.building.id
    weapon: ctx.weapon.id
    damage: ctx.damage
    kill: ctx.kill
    broken: ctx.broken
  else
    building: ctx.building.id
    weapon: ctx.weapon.id
    damage: ctx.damage
    broken: ctx.broken

get_settlement = (ctx) ->
  (cb) ->
    queries.get_settlement ctx.tile.settlement_id, (err, settlement) ->
      return cb(err) if err?
      ctx.settlement = settlement
      cb()

update_attacker = (ctx) ->
  (cb) ->
    return cb() unless ctx.hit
    query =
      _id: ctx.attacker._id
    update =
      $inc:
        xp_warrior: if ctx.kill then (ctx.damage + 20) else Math.ceil( (ctx.damage + 1) / 2)
    db.characters.update query, update, cb

break_weapon = (ctx) ->
  (cb) ->
    return cb() unless ctx.broken
    remove_item ctx.attacker, ctx.weapon, 1, cb

update_tile = (ctx) ->
  (cb) ->
    return cb() unless ctx.hit
    if ctx.kill
      destroy_building ctx.tile, cb
    else
      query =
        _id: ctx.tile._id
      update =
        $inc:
          hp: 0 - ctx.damage
      db.tiles.update query, update, cb

notify_attacker = (ctx) ->
  (cb) ->
    send_message 'demolish', ctx.attacker, ctx.attacker, format_msg ctx, cb

notify_nearby = (ctx) ->
  (cb) ->
    send_message_nearby 'demolish_nearby', ctx.attacker, [ctx.attacker], format_msg ctx, cb

notify_inside = (ctx) ->
  (cb) ->
    return cb() unless ctx.building.interior?
    coords =
      x: ctx.tile.x
      y: ctx.tile.y
      z: 1
    send_message_tile 'demolish_inside', ctx.attacker, coords, [], format_message ctx, cb

notify_settlement = (ctx) ->
  (cb) ->
    return cb() unless ctx.settlement?
    send_message_settlement 'demolish_settlement', ctx.attacker, ctx.settlement, [], format_msg ctx, cb

module.exports = (character, tile, weapon, cb) ->
  building = data.buildings[tile.building]
  accuracy = weapon.accuracy attacker, building, tile
  hit = Math.random() <= accuracy
  broken = if hit and weapon.break_odds then Math.random() <= weapon.break_odds else false
  damage = weapon.damage attacker, building, tile
  damage = tile.hp if damage > tile.hp
  kill = damage >= tile.hp

  context =
    character: character
    tile: tile
    building: building
    weapon: weapon
    accuracy: accuracy
    damage: damage
    hit: hit
    broken: broken
    kill: kill

  actions = []
  actions.push get_settlement
  actions.push notify_attacker
  actions.push break_weapon
  actions.push notify_nearby
  actions.push notify_inside
  actions.push notify_settlement
  actions.push update_attacker
  actions.push update_tile
  async.series actions.map (a) ->
    a context
  , cb
