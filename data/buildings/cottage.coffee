MAX_OCCUPANCY = 4

module.exports =
  name: 'Cottage'
  size: 'small'
  hp: 70
  interior: '_interior_cottage'
  upgrade: true
  actions: ['write']
  max_occupancy: MAX_OCCUPANCY

  recovery: (character, tile) ->
    return 0 unless character.hp > 0
    return 0 unless tile.z isnt 0
    return 0 unless tile.people?.length <= MAX_OCCUPANCY
    1

  build: (character, tile) ->
    takes:
      ap: 50
      building: 'cottage_pre'
      skill: 'construction'
      tools: ['stone_carpentry']
      items:
        timber: 10
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
        timber: 3
    gives:
      tile_hp: 5
      xp:
        crafter: 5

  text:
    built: 'You build the roof, and the cottage is complete.'
