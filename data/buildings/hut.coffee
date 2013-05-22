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
    max = @hp_max ? @hp
    return null unless tile.hp < max
    takes:
      ap: 4
      items:
        stick: 2
    gives:
      tile_hp: 3
      xp:
        crafter: 3
