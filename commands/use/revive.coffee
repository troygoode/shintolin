async = require 'async'
db = require '../../db'
remove_item = require '../remove_item'
send_message = require '../send_message'
send_message_nearby = require '../send_message_nearby'
give = require '../give'
default_heal_amount = 10

alter_healer_revives = (character, cb) ->
  query =
    _id: character._id
  update =
    $inc:
      revives: 1
  db.characters.update query, update, cb

alter_target_hp = (character, amount, cb) ->
  async.parallel [
    (cb) ->
      query =
        _id: character._id
      update =
        $set:
          hp: character.hp + amount
      db.characters.update query, update, cb
    (cb) ->
      query =
        x: character.x
        y: character.y
        z: character.z
        'people._id': character._id
      update =
        $set:
          'people.$.hp': character.hp + amount
      db.tiles.update query, update, cb
  ], cb

notify_user = (healer, target, item, amount, cb) ->
  send_message 'revive', healer, healer,
    item: item.id
    amount: amount
    target_id: target._id
    target_name: target.name
    target_slug: target.slug
  , cb

notify_target = (healer, target, item, amount, cb) ->
  send_message 'revived', healer, target,
    item: item.id
    amount: amount
  , cb

notify_nearby = (healer, target, item, amount, cb) ->
  send_message_nearby 'revive_nearby', healer, [healer, target],
    item: item.id
    amount: amount
    target_id: target._id
    target_name: target.name
    target_slug: target.slug
  , cb

module.exports = (healer, target, item, tile, cb) ->
  return cb('You cannot revive yourself.') unless healer._id.toString() isnt target._id.toString()
  return cb('Your target is not dazed.') unless target.hp <= 0

  get_amount_to_heal = null
  if typeof item.amount_to_heal is 'function'
    get_amount_to_heal = item.amount_to_heal
  else if item.amount_to_heal?
    get_amount_to_heal = (healer, target, tile, cb) ->
      cb null, item.amount_to_heal
  else
    get_amount_to_heal = (healer, target, tile, cb) ->
      cb null, default_heal_amount

  get_amount_to_heal healer, target, tile, (err, amount_to_heal) ->
    return next(err) if err?
    async.series [
      (cb) ->
        remove_item healer, item, 1, cb
      (cb) ->
        alter_healer_revives healer, cb
      (cb) ->
        alter_target_hp target, amount_to_heal, cb
      (cb) ->
        give.xp healer, tile, {herbalist: Math.round(amount_to_heal / 2) + 1}, cb
      (cb) ->
        notify_user healer, target, item, amount_to_heal, cb
      (cb) ->
        notify_target healer, target, item, amount_to_heal, cb
      (cb) ->
        notify_nearby healer, target, item, amount_to_heal, cb
    ], cb
