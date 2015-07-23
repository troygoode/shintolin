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
    return 0 unless character.hp > 0
    return 0 unless tile.z isnt 0
    return 0 unless tile.people?.length <= MAX_OCCUPANCY
    return 0 unless tile.settlement_id?.toString() is character.settlement_id?.toString()
    1

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
      skill: 'construction'
      items:
        timber: 4
    gives:
      tile_hp: 5
      xp:
        crafter: 5

  text:
    built: 'You build the roof, and the longhouse is complete.'
