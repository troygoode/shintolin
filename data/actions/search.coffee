_ = require 'underscore'
BPromise = require 'bluebird'
{items, terrains, buildings} = require '../'
db = require '../../db'
process_loot_table = BPromise.promisify(require('../../queries').process_loot_table)
send_message = BPromise.promisify(require('../../commands').send_message)
increment_search = BPromise.promisify(require('../../commands').increment_search)
give_items = require('../../commands').give.items
give_xp = require('../../commands').give.xp
remove_item = BPromise.promisify(require('../../commands').remove_item)
config = require '../../config'

resolve_terrain = (character, tile) ->
  building = buildings[tile.building] if tile?.building?
  terrain = if tile?.z is 0 and building?.exterior? then building.exterior else (tile?.terrain ? config.default_terrain)
  if _.isFunction terrain
    terrain = terrain character, tile
  terrain: terrains[terrain]
  building: building

roll_for_loot = (character, tile, suppress_increment) ->
  terrain = terrains[tile.terrain]
  BPromise.resolve()
    .then ->
      tile.searches ?= 0
      search_odds = terrain.search_odds(character, tile)
      for key, odds of search_odds
        item = items[key]
        if item.modify_search_odds?
          search_odds[key] = item.modify_search_odds odds
      process_loot_table search_odds
    .tap ([item_type]) ->
      return if suppress_increment or not item_type?
      increment_search tile
    .then ([item_type, total_odds]) ->
      return {item_type, total_odds}

take_from_tile = (character, tile, total_odds) ->
  return {total_odds: total_odds} unless tile?.items?.length
  item = tile.items[Math.floor(Math.random() * tile.items.length)]
  count = Math.floor(Math.random() * (if item.count > 10 then 10 else item.count)) + 1
  item_type: item.item
  count: count
  abandoned: true
  total_odds: total_odds

module.exports = (character, tile) ->
  update_tile = BPromise.promisify(db.tiles().update, db.tiles())
  {terrain, building} = resolve_terrain character, tile
  tags = (terrain?.tags ? []).concat(building?.tags ? [])
  return false if tags.indexOf('visible_inventory') isnt -1

  category: 'location'
  ap: 1

  execute: ->
    return send_message('search', character, character, unsearchable: true) unless terrain.search_odds?
    BPromise.resolve()
      .then ->
        roll_for_loot character, tile
      .then (result) ->
        return result if result?.item_type?
        take_from_tile character, tile, result?.total_odds ? 0
      .then (result) ->
        if result?.item_type?
          # item found
          item = items[result.item_type]
          count = result.count ? 1
          BPromise.resolve()

            .then ->
              if result.abandoned
                remove_item tile, item, count

            .then ->
              give_items character, null, {item: item.id, count: count}

            .then ->
              # shrink terrain?
              return if result.abandoned
              tile.searches = (tile.searches ? 0) + 1
              roll_for_loot(character, tile, true)
                .then (preview_result) ->
                  return if preview_result.total_odds > 0
                  new_terrain = terrain.shrink?(tile)
                  if new_terrain?
                    update_tile {_id: tile._id}, {$set: {terrain: new_terrain}}

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
          # nothing was found
          msg = {}
          if _.contains character.skills, 'foraging'
            msg.total_odds = result.total_odds
          send_message 'search', character, character, msg
