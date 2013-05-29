module.exports =
  name: 'Guardstand Foundation'
  size: 'large'
  hp: 40

  build: (character, tile) ->
    takes:
      ap: 50
      settlement: true
      skill: 'masonry'
      tools: ['masonry_tools']
      items:
        stone_block: 5
    gives:
      xp:
        crafter: 35

  repair: (character, tile) ->
    max = @hp_max ? @hp
    return null unless tile.hp < max
    takes:
      ap: 5
      items:
        stone_block: 1
    gives:
      tile_hp: 5
      xp:
        crafter: 1
