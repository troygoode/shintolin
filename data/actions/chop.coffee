_ = require 'underscore'

module.exports =
  ap: (character, tile) ->
    if _.contains(character.skills, 'lumberjack') then 4 else 8
