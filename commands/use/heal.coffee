async = require 'async'
db = require '../../db'
remove_item = require '../remove_item'
send_message = require '../send_message'
send_message_nearby = require '../send_message_nearby'
xp = require '../xp'
default_heal_amount = 5

alter_target_hp = (character, amount, cb) ->
  query =
    _id: character._id
  update =
    $inc:
      hp: amount
  db.characters.update query, update, cb

notify_user = (healer, target, item, amount, remaining, cb) ->
  send_message 'heal', healer, healer,
    item: item.id
    amount: amount
    remaining: remaining
    target_id: target._id
    target_name: target.name
    target_slug: target.slug
  , cb

notify_target = (healer, target, item, amount, remaining, cb) ->
  send_message 'healed', healer, target,
    item: item.id
    amount: amount
    remaining: remaining
  , cb

notify_nearby = (healer, target, item, amount, remaining, cb) ->
  send_message_nearby 'heal_nearby', healer, [healer, target],
    item: item.id
    amount: amount
    remaining: remaining
    target_id: target._id
    target_name: target.name
    target_slug: target.slug
  , cb

module.exports = (healer, target, item, tile, cb) ->
  return cb('Your target is already at full health.') unless target.hp < target.hp_max
  return cb('You cannot heal a dazed target without reviving them first.') unless target.hp > 0

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
    max_amount_to_heal = target.hp_max - target.hp
    amount_to_heal = max_amount_to_heal if max_amount_to_heal < amount_to_heal
    async.series [
      (cb) ->
        remove_item healer, item, 1, cb
      (cb) ->
        alter_target_hp target, amount_to_heal, cb
      (cb) ->
        wanderer = 0
        herbalist = Math.round(amount_to_heal / 2) + 1
        crafter = 0
        warrior = 0
        xp healer, wanderer, herbalist, crafter, warrior, cb
      (cb) ->
        notify_user healer, target, item, amount_to_heal, max_amount_to_heal - amount_to_heal, cb
      (cb) ->
        notify_target healer, target, item, amount_to_heal, max_amount_to_heal - amount_to_heal, cb
      (cb) ->
        notify_nearby healer, target, item, amount_to_heal, max_amount_to_heal - amount_to_heal, cb
    ], cb
