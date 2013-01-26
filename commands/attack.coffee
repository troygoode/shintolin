async = require 'async'
db = require '../db'
send_message = require './send_message'
send_message_nearby = require './send_message_nearby'
send_message_settlement = require './send_message_settlement'
queries = require '../queries'
days_until_full_status = 1

#TODO: handle item breakage

kicked_from_settlement = (attacker, target, kill) ->
  kill and attacker.settlement_id.toString() is target.settlement_id.toString() and target.settlement_provisional

calculate_frags = (target) ->
  Math.ceil(target.frags / 2)

update_attacker = (attacker, target, damage) ->
  (cb) ->
    kill = damage >= target.hp
    frags = if kill then calculate_frags(target) else 0
    xp = if kill then (damage + 20) else Math.ceil( (damage + 1) / 2)

    query =
      _id: attacker._id
    update =
      $inc:
        xp_warrior: xp
        frags: frags
    db.characters.update query, update, cb

update_target = (attacker, target, damage) ->
  (cb) ->
    kill = damage >= target.hp
    frags = if kill then calculate_frags(target) else 0

    query =
      _id: target._id
    update =
      $inc:
        hp: 0 - damage
        frags: 0 - frags
    if kicked_from_settlement attacker, target, kill
      update.$unset =
        settlement_id: 1
        settlement_name: 1
        settlement_slug: 1
        settlement_joined: 1
        settlement_provisional: 1
    db.characters.update query, update, cb

update_settlement = (attacker, target, damage) ->
  (cb) ->
    kill = damage >= target.hp
    return cb() unless kicked_from_settlement attacker, target, kill
    queries.get_settlement target.settlement_id.toString(), (err, settlement) ->
      return cb(err) if err?
      query =
        _id: settlement._id
      update =
        $inc:
          population: -1
        $pull:
          members:
            _id: target._id
      db.settlements.update query, update, false, true, cb

update_target_tile_hp = (attacker, target, damage) ->
  (cb) ->
    query =
      x: target.x
      y: target.y
      z: target.z
      'people._id': target._id
    update =
      $set:
        'people.$.hp': target.hp - damage
    db.tiles.update query, update, cb

notify_attacker_hit = (attacker, target, weapon, damage) ->
  (cb) ->
    kill = damage >= target.hp
    frags = if kill then calculate_frags(target) else 0
    kicked = kicked_from_settlement attacker, target, kill
    send_message 'attack', attacker, attacker,
      weapon: weapon.id
      target_id: target._id
      target_name: target.name
      target_slug: target.slug
      damage: damage
      kill: kill
      frags: frags
      kicked_from_settlement: kicked
      settlement_id: if kicked then target.settlement_id else undefined
      settlement_name: if kicked then target.settlement_name else undefined
      settlement_slug: if kicked then target.settlement_slug else undefined
    , cb

notify_target_hit = (attacker, target, weapon, damage) ->
  (cb) ->
    kill = damage >= target.hp
    frags = if kill then calculate_frags(target) else 0
    kicked = kicked_from_settlement attacker, target, kill
    send_message 'attacked', attacker, target,
      weapon: weapon.id
      damage: damage
      kill: kill
      frags: frags
      kicked_from_settlement: kicked
      settlement_id: if kicked then target.settlement_id else undefined
      settlement_name: if kicked then target.settlement_name else undefined
      settlement_slug: if kicked then target.settlement_slug else undefined
    , cb

notify_member_kicked = (attacker, target, weapon, damage) ->
  (cb) ->
    kill = damage >= target.hp
    return cb() unless kicked_from_settlement attacker, target, kill
    queries.get_settlement target.settlement_id.toString(), (err, settlement) ->
      return cb(err) if err?
      send_message_settlement 'kicked', attacker, settlement, [],
        settlement_id: target.settlement_id
        settlement_name: target.settlement_name
        settlement_slug: target.settlement_slug
        target_id: target._id
        target_name: target.name
        target_slug: target.slug
      , cb

notify_nearby_hit = (attacker, target, weapon, damage) ->
  (cb) ->
    kill = damage >= target.hp
    frags = if kill then calculate_frags(target) else 0
    kicked = kicked_from_settlement attacker, target, kill
    send_message_nearby 'attack_nearby', attacker, [attacker, target],
      weapon: weapon.id
      target_id: target._id
      target_name: target.name
      target_slug: target.slug
      damage: damage
      kill: kill
      frags: frags
      kicked_from_settlement: kicked
      settlement_id: if kicked then target.settlement_id else undefined
      settlement_name: if kicked then target.settlement_name else undefined
      settlement_slug: if kicked then target.settlement_slug else undefined
    , cb

notify_attacker_miss = (attacker, target, weapon) ->
  (cb) ->
    send_message 'attack', attacker, attacker,
      weapon: weapon.id
      target_id: target._id
      target_name: target.name
      target_slug: target.slug
    , cb

notify_target_miss = (attacker, target, weapon) ->
  (cb) ->
    send_message 'attacked', attacker, target,
      weapon: weapon.id
    , cb

notify_nearby_miss = (attacker, target, weapon) ->
  (cb) ->
    send_message_nearby 'attack_nearby', attacker, [attacker, target],
      weapon: weapon.id
      target_id: target._id
      target_name: target.name
      target_slug: target.slug
    , cb

module.exports = (attacker, target, tile, weapon, cb) ->
  accuracy = weapon.accuracy attacker, target, tile
  damage = weapon.damage attacker, target, tile
  damage = target.hp if damage > target.hp
  hit = Math.random() <= accuracy
  actions = []

  if hit
    actions.push update_attacker(attacker, target, damage)
    actions.push update_target(attacker, target, damage)
    actions.push update_settlement(attacker, target, damage)
    actions.push update_target_tile_hp(attacker, target, damage)
    actions.push notify_attacker_hit(attacker, target, weapon, damage)
    actions.push notify_target_hit(attacker, target, weapon, damage)
    actions.push notify_nearby_hit(attacker, target, weapon, damage)
    actions.push notify_member_kicked(attacker, target, weapon, damage)
  else
    actions.push notify_attacker_miss(attacker, target, weapon)
    actions.push notify_target_miss(attacker, target, weapon)
    actions.push notify_nearby_miss(attacker, target, weapon)

  async.parallel actions, cb
