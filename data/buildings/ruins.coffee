module.exports =
  id: 'ruins'
  name: 'Ruins'
  size: 'large'
  exterior: '_exterior_ruins'
  interior: '_interior_ruins'
  invulnerable: true

  recovery: (character, tile) ->
    if tile.z is 1
      .3
    else
      0

  build: (character, tile) ->
    takes:
      skill: '_mapmaker'
