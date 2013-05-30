_ = require 'underscore'

module.exports =
  name: 'honeycomb'
  plural: 'honeycombs'
  tags: ['usable', 'heal']
  weight: 1

  amount_to_heal: (healer, target, tile, cb) ->
    herb_lore = _.contains healer.skills, 'herb_lore'
    medicine = _.contains healer.skills, 'medicine'
    in_hospital = tile.z isnt 0 and tile.building is 'hospital'

    heal = 3
    heal += 2 if herb_lore
    heal += 2 if medicine and in_hospital
    cb null, heal
