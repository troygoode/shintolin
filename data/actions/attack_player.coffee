_ = require 'underscore'
Bluebird = require 'bluebird'
{items, creatures} = require '../'
get_character = Bluebird.promisify(require('../../queries').get_character)
attack = Bluebird.promisify(require('../../commands').attack)

by_efficacy = (character, tile) ->
  (ic) ->
    item = items[ic.item]
    return unless _.contains item?.tags, 'weapon'
    acc = item.accuracy character, null, tile
    dmg = item.damage character, null, tile
    (acc * dmg) * -1

by_name = (ic) ->
  item = items[ic.item]
  item.name

module.exports = (character, tile) ->
  targets = {}
  for t in (tile?.people ? [])
    if t._id.toString() isnt character._id.toString()
      if t.creature
        creature = creatures[t.creature]
        targets[t._id.toString()] = creature.name
      else
        targets[t._id.toString()] = t.name
  return false if _.isEmpty(targets)

  weapons = {}
  citems = character.items.slice(0)
  citems.unshift item: 'fist', count: 1
  for ic in _.chain(citems).sortBy(by_name).sortBy(by_efficacy(character, tile)).value()
    item = items[ic.item]
    if _.contains item?.tags, 'weapon'
      acc = item.accuracy character, null, tile
      dmg = item.damage character, null, tile
      weapons[item.id] = "#{item.name} (#{Math.floor(acc * 100)}%, #{dmg} DMG)"
  return false if _.isEmpty(weapons)

  category: 'target'
  ap: 1
  targets: targets
  weapons: weapons

  execute: (body) ->
    item = items[body.item]

    Bluebird.resolve()
      .then ->
        get_character body.target

      .then (target) ->
        throw 'Invalid Target' unless target?
        throw 'Invalid Weapon' unless _.contains item?.tags, 'weapon'
        inventory_item = _.find character.items, (i) ->
          i.item is item.id
        throw "You don\'t have a #{item.name}." unless inventory_item?
        throw 'Your target is already knocked out.' if target.hp < 1
        attack character, target, tile, item
