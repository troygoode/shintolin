module.exports =
  id: 'stone_block'
  name: 'stone block'

  craft: (character, tile) ->
    takes:
      ap: 10
      building: 'stonemasonry'
      skill: 'stone_working'
      items:
        boulder: 1
    gives:
      items:
        stone_block: 1
      xp:
        crafter: 6
