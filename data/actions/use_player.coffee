_ = require 'underscore'
BPromise = require 'bluebird'
data = require '../'
get_character = BPromise.promisify(require '../../queries/get_character')
use = require '../../commands/use'

module.exports = (character, tile) ->
  targets = (tile?.people ? []).filter (t) ->
    t._id.toString() isnt character._id.toString() and not t.creature?
  return false unless targets.length

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

  category: 'target'
  ap: 1
  usables: usables
  targets: targets

  execute: (body) ->
    BPromise.resolve()

      .then ->
        if body.target is 'self'
          character
        else
          get_character body.target

      .then (target) ->
        throw 'Invalid target.' unless target?
        item = data.items[body.item]
        throw 'Invalid item.' unless item? and _.contains(item.tags ? [], 'usable')
        use character, target, item, tile
