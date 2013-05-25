module.exports =
  id: 'kiln'
  name: 'Kiln'
  size: 'small'
  hp: 50

  build: (character, tile) ->
    takes:
      ap: 50
      settlement: true
      tools: ['masonry_tools']
      items:
        stone_block: 7
    gives:
      xp:
        crafter: 35

  repair: (character, tile) ->
    max = @hp_max ? @hp
    return null unless tile.hp < max
    takes:
      ap: 15
      tools: ['masonry_tools']
      items:
        stone_block: 1
    gives:
      tile_hp: 10
      xp:
        crafter: 5
