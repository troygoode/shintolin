module.exports =
  name: 'Cottage Foundation'
  size: 'small'
  hp: 30
  upgradeable_to: 'cottage'

  build: (character, tile) ->
    takes:
      ap: 50
      skill: 'masonry'
      tools: ['masonry_tools']
      items:
        stone_block: 6
    gives:
      xp:
        crafter: 35

  repair: (character, tile) ->
    max = @hp_max ? @hp
    return null unless tile.hp < max
    takes:
      ap: 10
      items:
        stone_block: 2
    gives:
      tile_hp: 10
      xp:
        crafter: 5

  text:
    built: 'You dig trenches for a foundation, then set to work building the walls of the cottage. It isn\'t finished yet: you still need to build the roof.'
