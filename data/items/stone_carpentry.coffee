module.exports =
  id: 'stone_carpentry'
  name: 'set of stone carpentry tools'
  plural: 'sets of stone carpentry tools'
  weight: 8
  break_odds: .04

  craft: (character, tile) ->
    takes:
      ap: 15
      skill: 'carpentry'
      items:
        handaxe: 4
        stick: 4
    gives:
      items:
        stone_carpentry: 1
      xp:
        crafter: 15
