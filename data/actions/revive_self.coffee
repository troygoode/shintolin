BPromise = require 'bluebird'
db = require '../../db'

DEFAULT_STARTING_HP = 10
DEFAULT_AP_COST = 24

module.exports = (character, tile) ->
  update_characters = BPromise.promisify(db.characters().update, db.characters())
  update_tiles = BPromise.promisify(db.tiles().update, db.tiles())
  send_message = BPromise.promisify(require '../../commands/send_message')
  send_message_nearby = BPromise.promisify(require '../../commands/send_message_nearby')

  return false unless character.hp is 0
  if character.revivable?
    ap_cost = 0
    starting_hp = character.revivable.hp
  else
    return false unless tile.z isnt 0
    return false unless character.settlement_id?.toString() is tile.settlement_id?.toString()
    ap_cost = DEFAULT_AP_COST
    starting_hp = DEFAULT_STARTING_HP

  category: 'self'
  ap: ap_cost
  allow_while_dazed: true
  starting_hp: starting_hp

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
