module.exports =
  id: 'masonry_tools'
  name: 'set of masonry tools'

  craft: (character, tile) ->
    takes:
      ap: 15
      skill: 'carpentry'
      building: 'workshop'
      items:
        handaxe: 2
        stone: 2
        stick: 4
    gives:
      items:
        masonry_tools: 1
      xp:
        crafter: 15
