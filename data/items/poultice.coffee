_ = require 'underscore'

module.exports =
  name: 'herbal poultice'
  plural: 'herbal poultices'
  tags: ['usable', 'revive']
  weight: 0

  amount_to_heal: (healer, target, tile, cb) ->
    herb_lore = _.contains healer.skills, 'herb_lore'
    medicine = _.contains healer.skills, 'medicine'
    in_hospital = tile.z isnt 0 and tile.building is 'hospital'

    heal = 5
    heal += 5 if medicine and in_hospital
    heal += 2 if herb_lore
    cb null, heal

  craft: (character, tile) ->
    ap = 10
    medicine = _.contains character.skills, 'medicine'
    in_hospital = tile.z isnt 0 and tile.building is 'hospital'
    ap -= 5 if medicine and in_hospital

    takes:
      ap: ap
      items:
        thyme: 5
        bark: 2
    gives:
      items:
        poultice: 1
      xp:
        herbalist: 5
        crafter: 1
