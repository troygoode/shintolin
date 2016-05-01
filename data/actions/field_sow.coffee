_ = require 'underscore'
Bluebird = require 'bluebird'
{items} = require '../'
COUNT = 10
AP_COST = 15
DEFAULT_TILE_HP_GROWTH = 1
OVERUSE_INCREASE = 12

commands = require '../../commands'
craft = commands.craft
increase_overuse = Bluebird.promisify(commands.increase_overuse)
send_message = Bluebird.promisify(commands.send_message)

module.exports = (character, tile) ->
  plantables = {}
  for ic in (character.items ? [])
    item = items[ic.item]
    if _.contains(item.tags ? [], 'plantable') and ic.count > COUNT
      plantables[item.id] = COUNT
  return false if _.isEmpty(plantables)

  category: 'location'
  ap: AP_COST
  charge_ap: false # done via recipe instead
  plantables: plantables

  execute: (body) ->
    item = items[body.item]
    Bluebird.resolve()
      .then ->
        throw 'Invalid Item' unless plantables[item?.id]?

      .then ->
        recipe =
          takes:
            ap: AP_COST
            skill: 'agriculture'
            season: ['spring', 'summer']
            items: {}
          gives:
            tile_hp: DEFAULT_TILE_HP_GROWTH
            xp:
              herbalist: 5
        recipe.takes.items[item.id] = COUNT
        craft character, tile, recipe

      .then ->
        increase_overuse tile, OVERUSE_INCREASE

      .then ->
        send_message 'sow', character, character, {}
