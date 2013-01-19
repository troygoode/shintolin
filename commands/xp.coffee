db = require '../db'

module.exports = (character, wanderer, herbalist, crafter, warrior, cb) ->
  query =
    _id: character._id
  update =
    $inc:
      xp_wanderer: wanderer
      xp_herbalist: herbalist
      xp_crafter: crafter
      xp_warrior: warrior
  db.characters.update query, update, cb
