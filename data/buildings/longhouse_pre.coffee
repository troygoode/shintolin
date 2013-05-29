module.exports =
  name: 'Longhouse Foundation'
  size: 'large'
  hp: 30

  build: (character, tile) ->
    takes:
      ap: 50
      settlement: true
      skill: 'construction'
      tools: ['stone_carpentry']
      items:
        timber: 12
    gives:
      xp:
        crafter: 35

  repair: (character, tile) ->
    max = @hp_max ? @hp
    return null unless tile.hp < max
    takes:
      ap: 10
      items:
        timber: 4
    gives:
      tile_hp: 5
      xp:
        crafter: 5

  text:
    built: 'You dig trenches for a foundation, then set to work building the walls of the longhouse. It isn\'t finished yet: you still need to build the roof.'
