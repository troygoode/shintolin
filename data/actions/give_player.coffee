_ = require 'underscore'
Bluebird = require 'bluebird'
{items} = require '../'
remove_item = Bluebird.promisify(require('../../commands').remove_item)
give_items = Bluebird.promisify(require('../../commands').give.items)
charge_ap = Bluebird.promisify(require('../../commands').charge_ap)
send_message = Bluebird.promisify(require('../../commands').send_message)
send_message_nearby = Bluebird.promisify(require('../../commands').send_message_nearby)
get_character = Bluebird.promisify(require('../../queries').get_character)
MAX_WEIGHT = 70

by_name = (ic) ->
  item = items[ic.item]
  item.name

module.exports = (character, tile) ->
  targets = (tile?.people ? []).filter (t) ->
    t._id.toString() isnt character._id.toString()
  return false unless targets.length

  giveables = {}
  for ic in _.sortBy(character.items, by_name)
    item = items[ic.item]
    unless item.nodrop or item.intrinsic
      if ic.count > 1
        giveables[item.id] = "#{item.plural} (#{ic.count}x total)"
      else
        giveables[item.id] = "#{item.name} (#{ic.count}x total)"
  return false if _.isEmpty(giveables)

  category: 'target'
  max_count: _.max(_.pluck(character.items, 'count'))
  giveables: giveables
  targets: targets

  execute: (body) ->
    item = items[body.item]
    quantity = parseInt(body.quantity ? 1)

    Bluebird.resolve()
      .then ->
        get_character body.target

      .then (target) ->
        throw 'Invalid Target' unless target?
        throw 'Invalid Target' if target._id.toString() is character._id.toString()
        throw 'Target Not Present' unless target.x is character.x and
          target.y is character.y and
          target.z is character.z
        throw 'Target Is Dazed' unless target.hp > 0

        Bluebird.resolve()
          .then ->
            throw 'Invalid Item' unless item?
            throw 'Invalid Item' if item.nodrop or item.intrinsic
            inventory_item = _.find character.items, (i) ->
              i.item is item.id
            throw "You don\'t have #{quantity} #{item.name} to give away." unless inventory_item.count >= quantity
            weight = quantity * (item.weight ? 0)
            throw "Giving that to #{target.name} would overburden them." if (target.weight + weight) > MAX_WEIGHT

          .then ->
            remove_item character, item, quantity

          .then ->
            give_items target, null, {item: item, count: quantity}

          .then ->
            charge_ap character, quantity

          .then ->
            send_message 'give', character, character,
              item: item.id
              quantity: quantity
              target_id: target._id
              target_name: target.name
              target_slug: target.slug

          .then ->
            send_message 'given', character, target,
              item: item.id
              quantity: quantity
              target_id: target._id
              target_name: target.name
              target_slug: target.slug

          .then ->
            send_message_nearby 'give_nearby', character, character,
              item: item.id
              quantity: quantity
              target_id: target._id
              target_name: target.name
              target_slug: target.slug
