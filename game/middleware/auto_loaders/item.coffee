data = require '../../../data'

module.exports = (req, res, next) ->
  item_type = req.param('item')
  return next() unless item_type?
  item = data.items[item_type]
  return next('Invalid item type.') unless item?
  req.item = item
  next()
