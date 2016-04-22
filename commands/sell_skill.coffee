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

  return cb('You cannot sell a skill you do not have.') unless _.find(character.skills, (s) ->
    s is skill.id)
  return cb("You cannot sell #{skill.skill.name} until you have sold all the skills that come after it.") if _.intersection(character.skills, _.pluck(skill.children, 'id')).length > 0

  async.series [
    (cb) ->
      xp_update =
        level: -1
      xp_update["level_#{xp_type.id}"] = -1
      query =
        _id: character._id
      update =
        $pull:
          skills: skill.id
        $inc: xp_update
      db.characters().updateOne query, update, cb
    , (cb) ->
      # notify character
      send_message 'unlearned', character, character,
        skill_id: skill.id
        skill_name: skill.skill.name
      , cb
  ], cb
