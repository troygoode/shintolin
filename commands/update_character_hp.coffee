async = require 'async'
db = require '../db'

module.exports = (character, new_hp, cb) ->
  async.parallel [
    (cb) ->
      query =
        _id: character._id
      update =
        $inc:
          hp: new_hp
      db.characters.update query, update, cb
    (cb) ->
      query =
        'people._id': character._id
      update =
        $set:
          'people.$.hp': new_hp
      db.tiles.update query, update, cb
  ], cb
