module.exports =
  id: 'bakery'
  name: 'Bakery'
  size: 'large'
  hp: 50
  interior: 'bakery_interior'
  upgrade: true
  actions: ['write']

  build: (character, tile) ->
    takes:
      ap: 50
      settlement: true
      building: 'longhouse'
      skill: 'masonry'
      items:
        stone_block: 7
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
    built: 'You build a stone oven in the building, converting it into a bakery.'
