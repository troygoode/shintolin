async = require 'async'
db = require '../db'

module.exports = (creature, cb) ->
  return cb('Invalid Creature') unless creature.creature?
  async.parallel [
    (cb) ->
      db.characters.remove _id: creature._id, cb
    (cb) ->
      query =
        'people._id': creature._id
      update =
        $pull:
          people:
            _id: creature._id
      db.tiles.update query, update, cb
  ], cb
