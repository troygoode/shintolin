_ = require 'underscore'
BPromise = require 'bluebird'
teleport = BPromise.promisify(require '../../commands/teleport')
get_character = BPromise.promisify(require('../../queries').get_character)
send_message = BPromise.promisify(require '../../commands/send_message')
send_message_nearby = BPromise.promisify(require '../../commands/send_message_nearby')

module.exports = (character, tile) ->
  return false unless tile? and tile.z is 1

  dazed = (tile?.people ? []).filter (p) ->
    p.hp <= 0
  return false unless dazed.length

  category: 'target'
  ap: 5
  people: dazed

  execute: (body) ->
    BPromise.resolve()

      .then ->
        get_character body.target

      .tap (target) ->
        teleport target, tile,
          x: tile.x
          y: tile.y
          z: 0

      .tap (target) ->
        msg =
          target_id: target._id
          target_name: target.name
          target_slug: target.slug
          building: tile.building
        BPromise.all [
          send_message 'kick_out', character, character, msg
          send_message 'kicked_out', character, target, msg
          send_message_nearby 'kick_out_nearby', character, [character, target], msg
        ]
