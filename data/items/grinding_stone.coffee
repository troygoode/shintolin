module.exports =
  name: 'grinding stone'
  plural: 'grinding stones'
  weight: 4

  break_odds: .01

  craft: (character, tile) ->
    takes:
      ap: 10
      skill: 'stone_working'
      building: 'stonemasonry'
      items:
        boulder: 1
    gives:
      items:
        grinding_stone: 1
      xp:
        crafter: 6
