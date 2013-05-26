module.exports =
  id: 'ruins'
  name: 'Ruins'
  size: 'large'
  interior: 'ruins_interior'
  invulnerable: true

  recovery: (character, tile) ->
    if tile.z is 1
      .3
    else
      0

  build: (character, tile) ->
    takes:
      skill: '_mapmaker'
