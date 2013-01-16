async = require 'async'
db = require '../db'
send_message = require './send_message'

module.exports = (attacker, target, tile, weapon, cb) ->
  accuracy = weapon.accuracy attacker, target, tile
  damage = weapon.damage attacker, target, tile
  hit = Math.random() <= accuracy

  if hit
    async.parallel [
      (cb) ->
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
        send_message attacker,
          type: 'attack'
          weapon: weapon.id
          target_id: target._id
          target_name: target.name
          damage: damage
          recipient_id: attacker._id
        , cb
      , (cb) ->
        send_message attacker,
          type: 'attacked'
          weapon: weapon.id
          damage: damage
          recipient_id: target._id
        , cb
    ], cb
  else
    async.parallel [
      (cb) ->
        send_message attacker,
          type: 'attack'
          weapon: weapon.id
          target_id: target._id
          target_name: target.name
          recipient_id: attacker._id
        , cb
      , (cb) ->
        send_message attacker,
          type: 'attacked'
          weapon: weapon.id
          recipient_id: target._id
        , cb
    ], cb
