_ = require 'underscore'
BPromise = require 'bluebird'

module.exports =
  prepare: (character, tile) ->
    BPromise.resolve
      category: 'location'
      ap: if _.contains(character.skills, 'lumberjack') then 4 else 8
