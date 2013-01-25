_ = require 'underscore'
async = require 'async'
db = require '../db'
skill_tree = require '../skill_tree'
data = require '../data'
send_message = require './send_message'

get_xp_type = (skill) ->
  in_tree = (root, skill) ->
    _.pluck(root.all, 'id').indexOf(skill.id) isnt -1
  return skill_tree.wanderer if in_tree skill_tree.wanderer, skill
  return skill_tree.crafter if in_tree skill_tree.crafter, skill
  return skill_tree.herbalist if in_tree skill_tree.herbalist, skill
  return skill_tree.warrior if in_tree skill_tree.warrior, skill
  throw 'buy_skill::get_xp_type has failed'

module.exports = (character, _skill, cb) ->
  xp_type = get_xp_type _skill
  skill = _.find xp_type.all, (s) ->
    s.id is _skill.id
  related_skills = _.intersection _.pluck(root.all, 'id'), character.skills
  cost = (2 + related_skills.length) * 30

  return cb('You are not able to buy that skill; either you already have it, or lack the required prerequisites.') if _.find(character.skills, skill.id)
  return cb('You are not able to buy that skill; either you already have it, or lack the required prerequisites.') unless _.difference(skill.ancestors, character.skills).length is 0
  return cb("You do not have sufficient #{xp_type.name} xp to buy that skill.") unless character["xp_#{xp_type.id}"] >= cost

  async.series [
    (cb) ->
      xp_update =
        level: 1
      xp_update["level_#{xp_type.id}"] = 1
      xp_update["xp_#{xp_type.id}"] = 0 - cost
      query =
        _id: character._id
      update =
        $push:
          skills: skill.id
        $inc: xp_update
      db.characters.update query, update, cb
    , (cb) ->
      # notify character
      send_message 'learned', character, character,
        skill_id: skill.id
        skill_name: skill.skill.name
      , cb
  ], cb
