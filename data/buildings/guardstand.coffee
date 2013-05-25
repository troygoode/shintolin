module.exports =
  id: 'guardstand'
  name: 'Guardstand'
  size: 'large'
  hp: 70
  upgrade: true
  exterior: 'wall_low'
  interior: 'guardstand_interior'

  recovery: (character, tile) ->
    .5

  build: (character, tile) ->
    takes:
      ap: 50
      building: 'guardstand_pre'
      skill: 'construction'
      tools: ['stone_carpentry']
      items:
        timber: 8
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

  cost_to_enter: (character, tile_from, tile_to) ->
    if tile_from? and tile_to? and tile_from.x is tile_to.x and tile_from.y is tile_to.y
      0
    else
      4
