_ = require 'underscore'
Bluebird = require 'bluebird'
{items} = require '../'
AP_COST = 16
DEFAULT_HARVEST_SIZE = 10

commands = require '../../commands'
craft = commands.craft
remove_building = Bluebird.promisify(commands.remove_building)
send_message = Bluebird.promisify(commands.send_message)

module.exports = (character, tile) ->
  harvestables = []
  for {item} in character.items
    if _.contains items[item].tags, 'harvest'
      harvestables.push(item)
  return false unless harvestables.length

  category: 'location'
  ap: AP_COST
  charge_ap: false # done via recipe instead
  harvestables: harvestables

  execute: (body) ->
    item = items[body.item]

    harvest_size = DEFAULT_HARVEST_SIZE
    if harvest_size > tile.hp
      harvest_size = tile.hp

    Bluebird.resolve()
      .then ->
        throw 'Invalid Item' unless item?
        throw 'That item cannot be used to harvest crops.' unless _.contains item.tags, 'harvest'

      .then ->
        recipe =
          takes:
            ap: if _.contains(item.tags, 'harvest+') then (AP_COST/2) else AP_COST
            skill: 'agriculture'
            season: 'autumn'
            tools: [item.id]
            tile_hp: harvest_size
          gives:
            items:
              wheat: harvest_size
            xp:
              herbalist: 4
        craft character, tile, recipe

      .then ->
        if harvest_size >= tile.hp
          remove_building tile

      .then ->
        send_message 'harvest', character, character,
          amount: harvest_size
          remaining: tile.hp - harvest_size
