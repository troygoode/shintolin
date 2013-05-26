module.exports =
  id: 'stone_sickle'
  name: 'stone sickle'
  plural: 'stone sickles'
  tags: ['weapon']
  weight: 2
  break_odds: .02

  craft: (character, tile) ->
    takes:
      ap: 10
      building: 'workshop'
      skill: 'carpentry'
      items:
        handaxe: 1
        stick: 1
    gives:
      items:
        stone_sickle: 1
      xp:
        crafter: 10
