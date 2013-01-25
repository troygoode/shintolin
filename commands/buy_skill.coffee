async = require 'async'
db = require '../db'

module.exports = (character, skill, cb) ->
  cost = 1
  xp_type = 'wanderer'

  async.series [
    (cb) ->
      xp_update = switch xp_type
        when 'wanderer'
          level: 1
          level_wanderer: 1
          xp_wanderer: 0 - cost
        when 'crafter'
          level: 1
          level_crafter: 1
          xp_crafter: 0 - cost
        when 'herbalist'
          level: 1
          level_herbalist: 1
          xp_herbalist: 0 - cost
        when 'warrior'
          level: 1
          level_warrior: 1
          xp_warrior: 0 - cost
      query =
        _id: character._id
      update =
        $push:
          skills: skill.id
        $inc: xp_update
      db.characters.update query, update, cb
    , (cb) ->
      #TODO: notify character
      cb()
  ], cb
