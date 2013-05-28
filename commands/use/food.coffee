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

alter_target_hpmax_and_hunger = (character, amount_hpmax, amount_hunger, cb) ->
  async.parallel [
    (cb) ->
      query =
        _id: character._id
      update =
        $set:
          hp_max: character.hp_max + amount_hpmax
          hunger: character.hunger + amount_hunger
      db.characters.update query, update, cb
    (cb) ->
      query =
        x: character.x
        y: character.y
        z: character.z
        'people._id': character._id
      update =
        $set:
          'people.$.hp_max': character.hp_max + amount_hpmax
      db.tiles.update query, update, cb
  ], cb

module.exports = (user, target, item, tile, cb) ->
  return cb('Your target is already full.') unless target.hunger < MAX_HUNGER

  hpmax_gain = bound_increase 3, target.hp_max, MAX_MAXHP
  hunger_gain = 1

  async.series [
    (cb) ->
      remove_item user, item, 1, cb
    (cb) ->
      alter_target_hpmax_and_hunger character, hpmax_gain, hunger_gain, cb
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
