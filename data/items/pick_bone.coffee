module.exports =
  id: 'pick_bone'
  name: 'bone pick'
  plural: 'bone picks'
  tags: ['pick']
  weight: 3
  break_odds: .05

  craft: (character, tile) ->
    takes:
      ap: 10
      building: 'workshop'
      skill: 'carpentry'
      tools: ['stone_carpentry']
      items:
        antler: 1
        stick: 1
    gives:
      items:
        pick_bone: 1
      xp:
        crafter: 10
