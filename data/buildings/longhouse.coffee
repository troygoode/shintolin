module.exports =
  id: 'longhouse'
  name: 'Longhouse'
  size: 'large'
  hp: 50
  interior: 'longhouse_interior'
  upgrade: true

  recovery: (character, tile) ->
    if tile.z is 1
      1
    else
      0

  build: (character, tile) ->
    takes:
      ap: 50
      building: 'longhouse_pre'
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
