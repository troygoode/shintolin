async = require 'async'
db = require '../db'
send_message = require './send_message'
send_message_nearby = require './send_message_nearby'
send_message_settlement = require './send_message_settlement'
remove_item = require './remove_item'
queries = require '../queries'
days_until_full_status = 1

kicked_from_settlement = (attacker, target, kill) ->
  return false unless kill and attacker.settlement_id?.length and target.settlement_id?.length
  kill and attacker.settlement_id.toString() is target.settlement_id.toString() and target.settlement_provisional

calculate_frags = (target) ->
  return 0 if target.creature?
  Math.ceil(target.frags / 2)

update_attacker = (attacker, target, weapon, damage, broken) ->
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
        kills: if kill then 1 else 0
    db.characters.update query, update, cb

break_weapon = (attacker, target, weapon, damage, broken) ->
  (cb) ->
    return cb() unless broken
    remove_item attacker, weapon, 1, cb

update_target = (attacker, target, weapon, damage, broken) ->
  (cb) ->
    kill = damage >= target.hp
    frags = if kill then calculate_frags(target) else 0

    if kill and target.creature?
      async.parallel [
        (cb) ->
          db.characters.remove _id: target._id, cb
        (cb) ->
          query =
            'people._id': target._id
          update =
            $pull:
              people:
                _id: target._id
          db.tiles.update query, update, cb
      ], cb
    else
      query =
        _id: target._id
      update =
        $inc:
          hp: 0 - damage
          frags: 0 - frags
          deaths: if kill then 1 else 0
      if kicked_from_settlement attacker, target, kill
        update.$unset =
          settlement_id: 1
          settlement_name: 1
          settlement_slug: 1
          settlement_joined: 1
          settlement_provisional: 1
      db.characters.update query, update, cb

update_settlement = (attacker, target, weapon, damage, broken) ->
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

update_target_tile_hp = (attacker, target, weapon, damage, broken) ->
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

notify_attacker_hit = (attacker, target, weapon, damage, broken) ->
  (cb) ->
    kill = damage >= target.hp
    frags = if kill then calculate_frags(target) else 0
    kicked = kicked_from_settlement attacker, target, kill
    send_message 'attack', attacker, attacker,
      weapon: weapon.id
      target_id: target._id
      target_creature: target.creature
      target_name: target.name
      target_slug: target.slug
      damage: damage
      kill: kill
      frags: frags
      kicked_from_settlement: kicked
      settlement_id: if kicked then target.settlement_id else undefined
      settlement_name: if kicked then target.settlement_name else undefined
      settlement_slug: if kicked then target.settlement_slug else undefined
      broken: if broken then broken else undefined
    , cb

notify_target_hit = (attacker, target, weapon, damage, broken) ->
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
      broken: if broken then broken else undefined
    , cb

notify_member_kicked = (attacker, target, weapon, damage, broken) ->
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
        target_creature: target.creature
        target_name: target.name
        target_slug: target.slug
      , cb

notify_nearby_hit = (attacker, target, weapon, damage, broken) ->
  (cb) ->
    kill = damage >= target.hp
    frags = if kill then calculate_frags(target) else 0
    kicked = kicked_from_settlement attacker, target, kill
    send_message_nearby 'attack_nearby', attacker, [attacker, target],
      weapon: weapon.id
      target_id: target._id
      target_creature: target.creature
      target_name: target.name
      target_slug: target.slug
      damage: damage
      kill: kill
      frags: frags
      kicked_from_settlement: kicked
      settlement_id: if kicked then target.settlement_id else undefined
      settlement_name: if kicked then target.settlement_name else undefined
      settlement_slug: if kicked then target.settlement_slug else undefined
      broken: if broken then broken else undefined
    , cb

notify_attacker_miss = (attacker, target, weapon, broken) ->
  (cb) ->
    send_message 'attack', attacker, attacker,
      weapon: weapon.id
      target_id: target._id
      target_creature: target.creature
      target_name: target.name
      target_slug: target.slug
      broken: if broken then broken else undefined
    , cb

notify_target_miss = (attacker, target, weapon, broken) ->
  (cb) ->
    send_message 'attacked', attacker, target,
      weapon: weapon.id
      broken: if broken then broken else undefined
    , cb

notify_nearby_miss = (attacker, target, weapon, broken) ->
  (cb) ->
    send_message_nearby 'attack_nearby', attacker, [attacker, target],
      weapon: weapon.id
      target_id: target._id
      target_creature: target.creature
      target_name: target.name
      target_slug: target.slug
      broken: if broken then broken else undefined
    , cb

module.exports = (attacker, target, tile, weapon, cb) ->
  #TODO: validate that weapon can be used to attack buildings (must be slash???)

  actions = []
  accuracy = weapon.accuracy attacker, target, tile
  damage = weapon.damage attacker, target, tile
  damage = target.hp if damage > target.hp
  hit = Math.random() <= accuracy
  creature = target.creature?
  broken = if hit and weapon.break_odds then Math.random() <= weapon.break_odds else false

  if hit
    actions.push update_attacker(attacker, target, weapon, damage, broken)
    actions.push break_weapon(attacker, target, weapon, damage, broken)
    actions.push update_target(attacker, target, weapon, damage, broken)
    actions.push update_settlement(attacker, target, weapon, damage, broken)
    actions.push update_target_tile_hp(attacker, target, weapon, damage, broken)
    actions.push notify_attacker_hit(attacker, target, weapon, damage, broken)
    unless creature
      actions.push notify_target_hit(attacker, target, weapon, damage, broken)
    actions.push notify_nearby_hit(attacker, target, weapon, damage, broken)
    unless creature
      actions.push notify_member_kicked(attacker, target, weapon, damage, broken)
  else
    actions.push break_weapon(attacker, target, weapon, null, broken)
    actions.push notify_attacker_miss(attacker, target, weapon, broken)
    unless creature
      actions.push notify_target_miss(attacker, target, weapon, broken)
    actions.push notify_nearby_miss(attacker, target, weapon, broken)

  async.parallel actions, cb
