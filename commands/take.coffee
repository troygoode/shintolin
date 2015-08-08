async = require 'async'
data = require '../data'
db = require '../db'
can_take = require '../queries/can_take'
remove_item = require './remove_item'
charge_ap = require './charge_ap'

bound_decrease = (decrease, current, min) ->
  if current - decrease >= min
    decrease
  else
    current - min

module.exports = (character, tile, takes, cb) ->
  {craftable, message, items_to_take, broken} = can_take character, tile, takes
  return cb(message) unless craftable

  async.series [
    (cb) ->
      # take items from inventory
      take_item = (item, cb) ->
        remove_item character, data.items[item.item], item.count, cb
      async.each items_to_take, take_item, cb
    (cb) ->
      # charge ap
      return cb() unless takes.ap?
      charge_ap character, takes.ap, cb
    (cb) ->
      # remove building HP
      return cb() unless tile.building? and takes.tile_hp?
      building = data.buildings[tile.building]
      query =
        _id: tile._id
      update =
        $inc:
          hp: 0 - bound_decrease(takes.tile_hp, tile.hp, 0)
      db.tiles.update query, update, cb
    (cb) ->
      # remove broken tools from inventory
      return cb() unless broken.length
      break_item = (item, cb) ->
        remove_item character, data.items[item], 1, cb
      async.each broken, break_item, cb
  ], (err) ->
    return cb(err) if err?
    cb null, broken
