module.exports =
  id: 'pick_ivory'
  name: 'ivory pick'
  plural: 'ivory picks'
  tags: ['pick', 'quarry']
  weight: 3
  break_odds: .0025

  craft: (character, tile) ->
    takes:
      ap: 15
      building: 'workshop'
      skill: 'carpentry'
      tools: ['stone_carpentry']
      items:
        ivory_tusk: 1
    gives:
      items:
        pick_ivory: 1
      xp:
        crafter: 15
