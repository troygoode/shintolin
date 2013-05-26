module.exports =
  id: 'stone_spear'
  name: 'stone spear'

  craft: (character, tile) ->
    takes:
      ap: 10
      skill: 'hafting'
      items:
        handaxe: 1
        staff: 1
    gives:
      items:
        stone_spear: 1
      xp:
        crafter: 10
