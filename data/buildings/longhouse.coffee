MAX_OCCUPANCY = 6

module.exports =
  name: 'Longhouse'
  size: 'large'
  hp: 50
  interior: '_interior_longhouse'
  upgrade: true
  actions: ['write']
  max_occupancy: MAX_OCCUPANCY
  upgradeable_to: ['bakery', 'hospital', 'workshop']

  recovery: (character, tile) ->
    if tile.z is 1 and tile.people?.length <= MAX_OCCUPANCY
      1
    else
      0

  build: (character, tile) ->
    takes:
      ap: 50
      settlement: true
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

  text:
    built: 'You build the roof, and the longhouse is complete.'
