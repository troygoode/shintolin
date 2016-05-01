Bluebird = require 'bluebird'

take_handlers = require '../commands/take/index'
calculate_broken = require './calculate_broken'

module.exports = (character, tile, takes) ->
  Bluebird.resolve()

    # can
    .then ->
      Object.keys(takes)
    .each (key) ->
      handler = take_handlers[key]?.can
      if handler?
        handler character, tile, takes[key]

    # broken
    .then ->
      calculate_broken(takes.tools ? [])
