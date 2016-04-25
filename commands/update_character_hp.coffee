async = require 'async'
db = require '../db'

db.register_index db.tiles,
  'people._id': 1

module.exports = (character, new_hp, cb) ->
  async.parallel [
    (cb) ->
      query =
        _id: character._id
      update =
        $set:
          hp: new_hp
      if new_hp <= 0
        update.$inc =
          deaths: 1
      db.characters().updateOne query, update, cb
    (cb) ->
      query =
        'people._id': character._id
      update =
        $set:
          'people.$.hp': new_hp
      db.tiles().updateMany query, update, cb
  ], cb
