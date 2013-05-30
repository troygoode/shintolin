_ = require 'underscore'

module.exports =
  name: 'honeycomb'
  plural: 'honeycombs'
  tags: ['usable', 'heal']
  weight: 1

  amount_to_heal: (healer, target, tile, cb) ->
    if _.contains healer.skills, 'herb_lore'
      5
    else
      3
