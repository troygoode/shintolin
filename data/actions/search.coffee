_ = require 'underscore'
BPromise = require 'bluebird'
{items, terrains} = require '../'
process_loot_table = BPromise.promisify(require('../../queries').process_loot_table)
send_message = BPromise.promisify(require('../../commands').send_message)
increment_search = BPromise.promisify(require('../../commands').increment_search)
give_items = BPromise.promisify(require('../../commands').give.items)
give_xp = BPromise.promisify(require('../../commands').give.xp)
remove_item = BPromise.promisify(require('../../commands').remove_item)

roll_for_loot = (character, tile) ->
  terrain = terrains[tile.terrain]
  BPromise.resolve()
    .then ->
      increment_search tile
    .then ->
      tile.searches ?= 1
      search_odds = terrain.search_odds(character, tile)
      for key, odds of search_odds
        item = items[key]
        if item.modify_search_odds?
          search_odds[key] = item.modify_search_odds odds
      process_loot_table search_odds
    .then ([item_type, total_odds]) ->
      return {item_type, total_odds}

take_from_tile = (character, tile) ->
  return {} unless tile?.items?.length
  item = tile.items[Math.floor(Math.random() * tile.items.length)]
  count = Math.floor(Math.random() * (if item.count > 10 then 10 else item.count)) + 1
  item_type: item.item
  count: count
  abandoned: true

module.exports = (character, tile) ->
  category: 'location'
  ap: 1

  execute: ->
    terrain = terrains[tile.terrain]
    return send_message('search', character, character, unsearchable: true) unless terrain.search_odds?
    BPromise.resolve()
      .then ->
        roll_for_loot character, tile
      .then (result) ->
        return result if result?.item_type?
        take_from_tile character, tile
      .then (result) ->
        if result?.item_type?
          item = items[result.item_type]
          count = result.count ? 1
          BPromise.resolve()
            .then ->
              if result.abandoned
                remove_item tile, item, count
            .then ->
              give_items character, null, {item: item.id, count: count}
            .then ->
              msg =
                item: item.id
                count: count
                abandoned: result.abandoned
              if _.contains character.skills, 'foraging'
                msg.total_odds = result.total_odds
              send_message 'search', character, character, msg
            .then ->
              give_xp character, tile, {wanderer: 1}
        else
          msg = {}
          if _.contains character.skills, 'foraging'
            msg.total_odds = result.total_odds
          send_message 'search', character, character, msg
