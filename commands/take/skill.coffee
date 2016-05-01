_ = require 'underscore'

module.exports.can = (character, tile, msg) ->
  if typeof msg is 'string'
    msg = [msg]
  unmet_skills = _.difference(msg, character.skills ? [])
  throw {
    message: "You must have the skill #{unmet_skills.join(',')} to do that."
    hard: true
  } if unmet_skills.length
