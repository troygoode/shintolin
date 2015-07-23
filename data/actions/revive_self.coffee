BPromise = require 'bluebird'
db = require '../../db'
update_character = BPromise.promisify(db.characters.update, db.characters)
send_message = BPromise.promisify(require '../../commands/send_message')
send_message_nearby = BPromise.promisify(require '../../commands/send_message_nearby')

STARTING_HP = 10

module.exports = (character, tile) ->
  return false unless character.hp is 0
  return false unless tile.z isnt 0
  return false unless character.settlement_id?.toString() is tile.settlement_id?.toString()

  category: 'self'
  ap: 24
  allow_while_dazed: true
  starting_hp: STARTING_HP

  execute: ->
    BPromise.resolve()
      .then ->
        query =
          _id: character._id
        update =
          $set:
            hp: STARTING_HP
        update_character query, update
      .then ->
        send_message 'revived', character, character,
          amount: STARTING_HP
      .then ->
        send_message_nearby 'revive_nearby', character, [character],
          amount: STARTING_HP
          target_id: character._id
          target_name: character.name
          target_slug: character.slug
