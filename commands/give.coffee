_ = require 'underscore'
async = require 'async'
data = require '../data'
add_item = require './add_item'
xp = require './xp'

module.exports = (character, tile, gives, cb) ->
  items_to_give = []
  items_to_give.push item: key, count: value for key, value of gives.items

  async.series [
    (cb) ->
      # give new items to inventory
      give_item = (item, cb) ->
        add_item character, data.items[item.item], item.count, cb
      async.each items_to_give, give_item, cb
    (cb) ->
      # grant xp
      xp character, gives.xp.wanderer ? 0, gives.xp.herbalist ? 0, gives.xp.crafter ? 0, gives.xp.warrior ? 0, cb
  ], (err) ->
    cb err, items_to_give
