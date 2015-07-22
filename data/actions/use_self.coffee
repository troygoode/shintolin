_ = require 'underscore'
BPromise = require 'bluebird'
data = require '../'
use = require '../../commands/use'

module.exports = (character, tile) ->
  usables = character.items
    .filter((i) ->
      item = data.items[i.item]
      i.count > 0 and _.contains(item.tags ? [], 'usable')
    ).map((i) ->
      item = data.items[i.item]
      id: item.id
      name: item.name
    )

  return false unless usables.length

  category: 'self'
  ap: 1
  usables: usables

  execute: (body) ->
    BPromise.resolve()
      .then ->
        item = data.items[body.item]
        throw 'Invalid item.' unless item? and _.contains(item.tags ? [], 'usable')
        use character, character, item, tile
