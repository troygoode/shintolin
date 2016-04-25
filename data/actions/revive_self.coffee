BPromise = require 'bluebird'
db = require '../../db'
{terrains} = require '../'
_ = require 'underscore'
moment = require 'moment'

DEFAULT_STARTING_HP = 10
DEFAULT_AP_COST = 48
REVIVE_COUNTER_HOURS = 24

module.exports = (character, tile) ->
  return false unless character.hp is 0

  update_characters = BPromise.promisify(db.characters().update, db.characters())
  update_tiles = BPromise.promisify(db.tiles().update, db.tiles())
  send_message = BPromise.promisify(require '../../commands/send_message')
  send_message_nearby = BPromise.promisify(require '../../commands/send_message_nearby')
  NOW = new Date()
  has_skill = (skill) ->
    _.contains(character.skills ? [], skill)

  available_on = (() ->
    last_death = character.last_death ? character.last_action
    moment(last_death).add(REVIVE_COUNTER_HOURS, 'hours')._d
  )()

  too_soon = (() ->
    available_on > NOW
  )()

  is_in_hospital = (() ->
    return false unless tile.z isnt 0
    return false unless character.settlement_id?.toString() is tile.settlement_id?.toString()
    t = terrains[tile.terrain]
    return false unless _.contains(t.actions ? [], 'revive_self')
    true
  )()

  in_inhospitable_settlement = (() ->
    return true if tile.settlement_id? and character.settlement_id?.toString() isnt tile.settlement_id?.toString()
    return true if character.settlement_provisional
    false
  )()

  if character.revivable?
    ap_cost = 0
    starting_hp = character.revivable.hp
  else if too_soon
    return {
      too_soon: too_soon
      available_on: available_on
    }
  else if in_inhospitable_settlement
    return {in_inhospitable_settlement: true}
  else if is_in_hospital
    ap_cost = if has_skill('hospitaller') then (DEFAULT_AP_COST / 4) else (DEFAULT_AP_COST / 2)
    starting_hp = if has_skill('medicine') then (DEFAULT_STARTING_HP * 3) else (DEFAULT_STARTING_HP * 2)
  else
    ap_cost = DEFAULT_AP_COST
    starting_hp = DEFAULT_STARTING_HP

  category: 'self'
  ap: ap_cost
  allow_while_dazed: true
  starting_hp: starting_hp
  is_in_hospital: is_in_hospital
  in_inhospitable_settlement: in_inhospitable_settlement
  too_soon: false

  execute: ->
    BPromise.resolve()

      .then ->
        query =
          _id: character._id
        update =
          $set:
            hp: starting_hp
            last_revived: new Date()
          $unset:
            revivable: true
        update_characters query, update

      .then ->
        query =
          'people._id': character._id
        update =
          $set:
            'people.$.hp': starting_hp
          $unset:
            'people.$.revivable': true
        update_tiles query, update

      .then ->
        send_message 'revived', character, character,
          amount: starting_hp

      .then ->
        send_message_nearby 'revive_nearby', character, [character],
          amount: starting_hp
          target_id: character._id
          target_name: character.name
          target_slug: character.slug
