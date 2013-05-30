module.exports =
  name: 'set of masonry tools'
  plural: 'sets of masonry tools'
  weight: 8
  break_odds: .04

  craft: (character, tile) ->
    takes:
      ap: 15
      skill: 'stone_working'
      building: 'workshop'
      items:
        axe_hand: 2
        stone: 2
        stick: 4
    gives:
      items:
        masonry_tools: 1
      xp:
        crafter: 15
