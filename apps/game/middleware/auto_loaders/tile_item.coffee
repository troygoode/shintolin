_ = require 'underscore'
data = require '../../../../data'

in_inventory = (tile, item) ->
  return true if item.intrinsic
  _.some tile.items ? [], (i) ->
    i.item is item.id

module.exports = (req, res, next) ->
  item_type = req.param('tile_item')
  return next() unless item_type?
  item = data.items[item_type]
  return next('Invalid item type.') unless item?
  req.tile_item = item if in_inventory req.tile, item
  next()
