async = require 'async'
db = require '../db'

db.register_index db.tiles,
  'people._id': 1

module.exports = (character, new_hp, cb) ->
  async.parallel [
    (cb) ->
      QUERY =
        _id: character._id
      UPDATE =
        $set:
          hp: new_hp

      if character.hp > 0 and new_hp <= 0
        UPDATE.$set.last_death = new Date()
        UPDATE.$inc =
          deaths: 1
      else if new_hp > 0
        UPDATE.$unset =
          revivable: true

      db.characters().updateOne QUERY, UPDATE, cb
    (cb) ->
      QUERY =
        'people._id': character._id
      UPDATE =
        $set:
          'people.$.hp': new_hp
      db.tiles().updateMany QUERY, UPDATE, cb
  ], cb
