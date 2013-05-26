_ = require 'underscore'
async = require 'async'
db = require '../db'
data = require '../data'
add_item = require './add_item'
xp = require './xp'

bound_increase = (increase, current, max) ->
  if current > max
    max - current
  else if current + increase >= max
    max - current
  else
    increase

module.exports = (character, tile, gives, cb) ->
  items_to_give = []
  items_to_give.push item: key, count: value for key, value of gives.items

  async.parallel [
    (cb) ->
      # give new items to inventory
      give_item = (item, cb) ->
        add_item character, data.items[item.item], item.count, cb
      async.each items_to_give, give_item, cb
    (cb) ->
      # grant xp
      return cb() unless gives?.xp?
      xp character, gives.xp.wanderer ? 0, gives.xp.herbalist ? 0, gives.xp.crafter ? 0, gives.xp.warrior ? 0, cb
    (cb) ->
      # grant building HP
      return cb() unless tile.building? and gives.tile_hp?
      building = data.buildings[tile.building]
      query =
        _id: tile._id
      update =
        $inc:
          hp: bound_increase gives.tile_hp, tile.hp, (building.hp_max ? building.hp)
      console.log update
      db.tiles.update query, update, cb
  ], cb
