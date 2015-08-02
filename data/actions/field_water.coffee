_ = require 'underscore'
Bluebird = require 'bluebird'
{items, buildings} = require '../'
AP_COST = 1
DEFAULT_TILE_HP_GROWTH = 3

commands = require '../../commands'
craft = Bluebird.promisify(commands.craft)
water_field = Bluebird.promisify(commands.water_field)
send_message = Bluebird.promisify(commands.send_message)

module.exports = (character, tile) ->
  waterables = []
  for {item} in character.items
    if _.contains items[item].tags, 'water'
      waterables.push(item)
  return false unless waterables.length
  return false if tile.watered

  category: 'location'
  ap: AP_COST
  charge_ap: false # done via recipe instead
  waterables: waterables

  execute: (body) ->
    item = items[body.item]
    building = buildings[tile.building]

    growth = DEFAULT_TILE_HP_GROWTH
    if tile.hp + growth > building.hp_max
      growth = building.hp_max - tile.hp

    Bluebird.resolve()
      .then ->
        throw 'Already Watered' if tile.watered
        throw 'Invalid Item' unless waterables.indexOf(item?.id) isnt -1

      .then ->
        recipe =
          takes:
            ap: AP_COST
            season: ['spring', 'summer']
            items: {}
          gives:
            tile_hp: growth
            items: {}
            xp:
              herbalist: 3
        recipe.takes.items[item.id] = 1
        if item.actions?.field_water?.gives?
          recipe.gives.items[item.actions.field_water.gives] = 1
        craft character, tile, recipe, null

      .then ->
        water_field tile

      .then ->
        send_message 'water', character, character, {}
