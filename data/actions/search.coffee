_ = require 'underscore'
BPromise = require 'bluebird'
{items, terrains} = require '../'
process_loot_table = BPromise.promisify(require('../../queries').process_loot_table)
send_message = BPromise.promisify(require('../../commands').send_message)
increment_search = BPromise.promisify(require('../../commands').increment_search)
give_items = BPromise.promisify(require('../../commands').give.items)
give_xp = BPromise.promisify(require('../../commands').give.xp)

#TODO: find abandoned items
# https://github.com/Buttercup2k/Shintolin/blob/master/functions.cgi#L2654

module.exports = (character, tile) ->
  category: 'location'
  ap: 1

  execute: ->
    terrain = terrains[tile.terrain]
    return send_message('search', character, character, unsearchable: true) unless terrain.search_odds?

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
        if item_type?
          BPromise.resolve()
            .then ->
              give_items character, null, {item: item_type, count: 1}
            .then ->
              msg =
                item: item_type
              if _.contains character.skills, 'foraging'
                msg.total_odds = total_odds
              send_message 'search', character, character, msg
            .then ->
              give_xp character, tile, {wanderer: 1}
        else
          msg = {}
          if _.contains character.skills, 'foraging'
            msg.total_odds = total_odds
          send_message 'search', character, character, msg
