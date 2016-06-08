_ = require 'underscore'
Bluebird = require 'bluebird'
{items} = require '../'
take = Bluebird.promisify(require('../../commands').take)
give_items = require('../../commands').give.items
send_message = Bluebird.promisify(require('../../commands').send_message)

by_name = (ic) ->
  item = items[ic.item]
  item.name

by_weight = (ic) ->
  item = items[ic.item]
  (ic.count + (ic.count * (item.weight ? 0))) * -1

module.exports = (character, tile) ->
  droppables = {}
  for ic in _.chain(character.items).sortBy(by_name).sortBy(by_weight).value()
    item = items[ic.item]
    unless item.nodrop or item.intrinsic
      if ic.count > 1
        droppables[item.id] = "#{item.plural} (#{ic.count}x total)"
      else
        droppables[item.id] = "#{item.name} (#{ic.count}x total)"

  category: 'self'
  droppables: droppables
  max_count: _.max(_.pluck(character.items, 'count'))

  execute: (body) ->
    item = items[body.item]
    count = parseInt(body.count ? 1)

    Bluebird.resolve()
      .then ->
        throw 'Invalid Item' unless item?
        throw 'Invalid Item' if item.nodrop or item.intrinsic

        recipe =
          takes:
            items: {}
        recipe.takes.items[item.id] = count
        take character, tile, recipe.takes

      .then ->
        give_items null, tile,
          item: item
          count: count

      .then (recipe) ->
        send_message 'drop', character, character,
          item: item.id
          quantity: count
