module.exports =
  id: 'hut'
  name: 'Hut'
  size: 'small'
  hp: 30
  interior: 'hut_interior'

  build: (character, tile) ->
    takes:
      ap: 40
      items:
        stick: 20
        staff: 5
    gives:
      xp:
        crafter: 25

  repair: (character, tile) ->
    return null unless tile.hp < @hp
    gives:
      tile_hp: 3
    takes:
      ap: 10
      items:
        stick: 10
