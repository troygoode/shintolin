db = require '../db'
data = require '../data'

module.exports = (character, badge_id, cb) ->
  badge = data.badges[badge_id]
  return cb('Invalid Badge') unless badge?

  badges = character.badges ? {}
  return cb() if badges[badge.id]?

  badges[badge.id] = new Date()

  query =
    _id: character._id
  update =
    $set:
      badges: badges
  db.characters().updateOne query, update, cb
