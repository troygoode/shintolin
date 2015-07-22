BPromise = require 'bluebird'
data = require '../data'
usable_commands = require './use/index'

module.exports = (character, target, item, tile) ->
  promises = []

  # find handlers for the tags
  item.tags.forEach (tag) ->
    handler = usable_commands[tag]
    if handler?
      promises.push BPromise.promisify(handler)

  # is the item directly usable?
  if item.use?
    promises.push BPromise.promisify(item.use)

  BPromise.all promises.map (p) ->
    p character, target, item, tile
