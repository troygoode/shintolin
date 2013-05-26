module.exports =
  id: 'cottage'
  name: 'Cottage'
  size: 'large'
  hp: 70
  interior: 'cottage_interior'
  upgrade: true
  actions: ['write']

  recovery: (character, tile) ->
    if tile.z is 1
      1
    else
      0

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
      items:
        timber: 3
    gives:
      tile_hp: 5
      xp:
        crafter: 5

  text:
    built: 'You build the roof, and the cottage is complete.'
