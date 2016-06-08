module.exports =
  name: 'Bakery'
  size: 'large'
  hp: 100
  interior: '_interior_bakery'
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
      skill: 'masonry'
      items:
        stone_block: 2
    gives:
      tile_hp: 25
      xp:
        crafter: 5

  text:
    built: 'You build a stone oven in the building, converting it into a bakery.'
