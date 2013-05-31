_ = require 'underscore'
async = require 'async'
db = require '../db'
queries = require '../queries'
remove_creature = require './remove_creature'
remove_from_settlement = require './remove_from_settlement'
remove_item = require './remove_item'
send_message = require './send_message'
send_message_nearby = require './send_message_nearby'
send_message_settlement = require './send_message_settlement'
update_character_hp = require './update_character_hp'

update_attacker = (ctx, cb) ->
  async.parallel [
    (cb) ->
      return cb() unless ctx.hit
      xp = if ctx.kill then (ctx.damage + 20) else Math.ceil( (ctx.damage + 1) / 2)
      query =
        _id: ctx.attacker._id
      update =
        $inc:
          xp_warrior: xp
      db.characters.update query, update, cb
    (cb) ->
      return cb() unless ctx.kill
      query =
        _id: ctx.attacker._id
      update =
        $inc:
          frags: ctx.frags
          kills: 1
      db.characters.update query, update, cb
    (cb) ->
      return cb() unless ctx.is_weapon_broken
      remove_item ctx.attacker, ctx.weapon, 1, cb
  ], cb

update_target = (ctx, cb) ->
  if ctx.kill and ctx.is_creature
    remove_creature ctx.target, cb
  else
    async.parallel [
      (cb) ->
        update_character_hp ctx.target, ctx.target.hp - ctx.damage, cb
      (cb) ->
        return cb() unless ctx.kill
        query =
          _id: ctx.target._id
        update =
          $inc:
            frags: 0 - ctx.frags
            deaths: -1
        db.characters.update query, update, cb
      (cb) ->
        return cb() unless ctx.remove_from_settlement
        remove_from_settlement ctx.target, cb
    ], cb

format_message = (ctx) ->
  msg =
    weapon: ctx.weapon.id
    broken: ctx.is_weapon_broken
    target_id: ctx.target._id
    target_creature: ctx.target.creature
    target_name: ctx.target.name
    target_slug: ctx.target.slug
  if ctx.hit
    msg = _.extend msg,
      damage: ctx.damage
      kill: ctx.kill
      frags: ctx.frags
  if ctx.remove_from_settlement
    msg = _.extend msg,
      kicked_from_settlement: true
      settlement_id: ctx.target.settlement_id
      settlement_name: ctx.target.settlement_name
      settlement_slug: ctx.target.settlement_slug
  msg

notify = (ctx, cb) ->
  async.parallel [
    (cb) ->
      send_message 'attack', ctx.attacker, ctx.attacker, ctx.message, cb
    (cb) ->
      return cb() if ctx.is_creature
      send_message 'attacked', ctx.attacker, ctx.target, ctx.message, cb
    (cb) ->
      send_message_nearby 'attack_nearby', ctx.attacker, [ctx.attacker, ctx.target], ctx.message, cb
    (cb) ->
      return cb() unless ctx.remove_from_settlement
      queries.get_settlement ctx.target.settlement_id, (err, settlement) ->
        return cb(err) if err?
        send_message_settlement 'kicked', ctx.attacker, settlement, [], ctx.message, cb
  ], cb

module.exports = (attacker, target, tile, weapon, cb) ->
  ctx =
    attacker: attacker
    target: target
    tile: tile
    weapon: weapon
    is_creature: target.creature?

  # hit?
  accuracy = weapon.accuracy attacker, target, tile
  ctx.hit = Math.random() <= accuracy

  # item breakage?
  ctx.is_weapon_broken = if ctx.hit and ctx.weapon.break_odds then Math.random() <= weapon.break_odds else false

  # determine damage
  dmg = weapon.damage attacker, target, tile
  ctx.damage = if dmg > target.hp then target.hp else dmg

  # kill?
  ctx.kill = target.hp - ctx.damage <= 0
  ctx.frags = if not ctx.kill or ctx.is_creature then 0 else Math.ceil(ctx.target.frags / 2)

  # remove from settlement?
  if ctx.kill and not ctx.is_creature
    is_provisional = target.settlement_provisional? and target.settlement_provisional
    same_settlement = attacker.settlement_id?.length and target.settlement_id?.length and attacker.settlement_id.toString() is target.settlement_id.toString()
    ctx.remove_from_settlement = is_provisional and same_settlement

  # message
  ctx.message = format_message ctx

  async.parallel [
    (cb) ->
      update_attacker ctx, cb
    (cb) ->
      update_target ctx, cb
    (cb) ->
      notify ctx, cb
  ], cb
