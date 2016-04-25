_ = require 'underscore'

module.exports =
  name: 'cup of herbal tea'
  plural: 'cups of herbal tea'
  tags: ['usable', 'revive']
  weight: 0

  amount_to_heal: (healer, target, tile, cb) ->
    herb_lore = _.contains healer.skills, 'herb_lore'
    medicine = _.contains healer.skills, 'medicine'
    in_hospital = tile.z isnt 0 and tile.building is 'hospital'

    if target.hp is 0
      heal = 20
      heal += 10 if medicine and in_hospital
      heal += 20 if herb_lore
    else
      heal = 10
      heal += 5 if medicine and in_hospital
      heal += 10 if herb_lore
    cb null, heal

  craft: (character, tile) ->
    ap = 10
    medicine = _.contains character.skills, 'medicine'
    in_hospital = tile.z isnt 0 and tile.building is 'hospital'
    ap -= 5 if medicine and in_hospital

    takes:
      ap: ap
      building: 'campfire'
      skill: 'tea_making'
      items:
        thyme: 2
        bark: 2
    gives:
      items:
        tea: 1
      xp:
        herbalist: 5
        crafter: 1
