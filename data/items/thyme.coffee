_ = require 'underscore'
time = require '../../time'

module.exports =
  name: 'thyme sprig'
  plural: 'thyme sprigs'
  tags: ['usable', 'heal']
  weight: 0

  amount_to_heal: (healer, target, tile, cb) ->
    herb_lore = _.contains healer.skills, 'herb_lore'
    medicine = _.contains healer.skills, 'medicine'
    in_hospital = tile.z isnt 0 and tile.building is 'hospital'

    heal = 5
    heal += 2 if herb_lore
    heal += 2 if medicine and in_hospital
    cb null, heal

  modify_search_odds: (odds) ->
    switch time().season
      when 'Autumn' then odds * .7
      when 'Winter' then odds * .5
      else odds
