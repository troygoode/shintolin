_ = require 'underscore'
Bluebird = require 'bluebird'
{terrains} = require '../'

commands = require '../../commands'
craft = commands.craft
send_message = Bluebird.promisify(commands.send_message)
increment_search = Bluebird.promisify(commands.increment_search)

queries = require '../../queries'
process_loot_table = Bluebird.promisify(queries.process_loot_table)

module.exports = (character, tile) ->
  return false unless _.contains character.skills, 'foraging'

  category: 'location'
  ap: 2
  charge_ap: false # done via recipe instead

  execute: ->
    terrain = terrains[tile.terrain]
    Bluebird.resolve()
      .then ->
        throw 'This terrain does not support digging.' unless terrain?.dig_odds?

      .then ->
        loot_table = terrain.dig_odds character, tile
        process_loot_table loot_table

      .tap ([found_item_type]) ->
        increment_search(tile) if found_item_type?

      .then ([found_item_type, total_odds]) ->
        recipe =
          takes:
            ap: 2
            tools: ['spade']
        if found_item_type?
          recipe.gives =
            items: {}
            xp:
              wanderer: 1
          recipe.gives.items[found_item_type] = 1

        craft(character, tile, recipe)
          .then ({broken_items}) ->
            send_message 'dig', character, character,
              found: found_item_type
              broken: broken_items?.length > 0
              broken_item: broken_items[0]
