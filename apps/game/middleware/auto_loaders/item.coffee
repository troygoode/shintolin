_ = require 'underscore'
data = require '../../../../data'

in_inventory = (character, item) ->
  return true if item.intrinsic
  _.some character.items, (i) ->
    i.item is item.id

module.exports = (req, res, next) ->
  item_type = req.param('item')
  return next() unless item_type?
  item = data.items[item_type]
  return next('Invalid item type.') unless item?
  req.item = item if in_inventory req.character, item
  next()
