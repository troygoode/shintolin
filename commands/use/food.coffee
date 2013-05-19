async = require 'async'
db = require '../../db'
send_message = require '../send_message'
remove_item = require '../remove_item'
MAX_MAXHP = 50
MAX_HUNGER = 12

bound_increase = (increase, current, max) ->
  if current >= max
    current
  else if current + increase > max
    max - current
  else
    increase

module.exports = (user, target, item, tile, cb) ->
  return cb('Your target is already full.') unless target.hunger < MAX_HUNGER

  hpmax_gain = bound_increase 3, target.hp_max, MAX_MAXHP
  hunger_gain = 1

  async.series [
    (cb) ->
      remove_item user, item, 1, cb
    (cb) ->
      query =
        _id: target._id
      update =
        $inc:
          hunger: hunger_gain
          hp_max: hpmax_gain
      db.characters.update query, update, cb
    (cb) ->
      send_message 'feed', user, user,
        item: item.id
        hpmax_gain: hpmax_gain
        target_id: target._id
        target_name: target.name
        target_slug: target.slug
      , cb
    (cb) ->
      if user._id.toString() is target._id.toString()
        cb()
      else
        send_message 'fed', user, target,
          item: item.id
          hpmax_gain: hpmax_gain
        , cb
  ], cb
