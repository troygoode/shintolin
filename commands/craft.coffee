async = require 'async'
data = require '../data'
give = require './give'
take = require './take'
send_message = require './send_message'

module.exports = (character, tile, recipe, cb) ->
  return cb('Invalid recipe') unless recipe?

  to_take = recipe.takes character
  to_give = recipe.gives character

  async.waterfall [
    (cb) ->
      take character, tile, to_take, cb
    (items_to_take, broken_items, cb) ->
      give character, tile, to_give, (err, items_to_give) ->
        cb err, items_to_take, broken_items, items_to_give
    (items_to_take, broken_items, items_to_give, cb) ->
      # notify user of success
      send_message 'craft', character, character,
        recipe: recipe.name
        received: items_to_give
        broken: broken_items
      , cb
  ], cb
