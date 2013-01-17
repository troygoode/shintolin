async = require 'async'
db = require '../db'
send_message = require './send_message'
charge_ap = require './charge_ap'

module.exports = (attacker, target, tile, weapon, cb) ->
  return cb('Your target is already knocked out.') if target.hp <= 0

  accuracy = weapon.accuracy attacker, target, tile
  damage = weapon.damage attacker, target, tile
  hit = Math.random() <= accuracy
  kill = damage >= target.hp

  #TODO: validate that user has the weapon in inventory and that it is a weapon
  #TODO: validate that the target is in the same square
  #TODO: announce attack to other characters on this tile
  #TODO: handle dazing
  #        - transfer frags
  #        - grant extra xp
  #TODO: handle item breakage
  #TODO: handle attacking animals
  #        - grant xp
  #        - loot on kill
  #        - attack back

  if hit
    async.parallel [
      (cb) ->
        xp = if kill then 21 else 1
        xp = if kill
            (damage + 20)
          else
            Math.ceil( (damage + 1) / 2)
        query =
          _id: attacker._id
        update =
          $inc:
            xp_warrior: xp
        db.characters.update query, update, cb
      , (cb) ->
        query =
          _id: target._id
        update =
          $set:
            hp: target.hp - damage
        db.characters.update query, update, cb
      , (cb) ->
        query =
          x: target.x
          y: target.y
          z: target.z
          'people._id': target._id
        update =
          $set:
            'people.$.hp': target.hp - damage
        db.tiles.update query, update, cb
      , (cb) ->
        send_message 'attack', attacker, attacker,
          weapon: weapon.id
          target_id: target._id
          target_name: target.name
          damage: damage
        , cb
      , (cb) ->
        send_message 'attacked', attacker, target,
          weapon: weapon.id
          damage: damage
        , cb
    ], cb
  else # MISS
    async.parallel [
      (cb) ->
        send_message 'attack', attacker, attacker,
          weapon: weapon.id
          target_id: target._id
          target_name: target.name
        , cb
      , (cb) ->
        send_message 'attacked', attacker, target,
          weapon: weapon.id
        , cb
    ], cb
