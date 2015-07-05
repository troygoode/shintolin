data = require '../data'

module.exports = (items) ->
  weight = 0
  for item in (items ? [])
    item_type = data.items[item.item]
    weight = weight + item_type.weight * item.count
  weight
