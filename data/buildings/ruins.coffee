module.exports =
  name: 'Ruins'
  size: 'large'
  exterior: '_exterior_ruins'
  interior: '_interior_ruins'
  invulnerable: true
  tags: ['no_storm_damage']

  recovery: (character, tile) ->
    if tile.z is 1
      .3
    else
      0

  build: (character, tile) ->
    takes:
      developer: true

  cost_to_enter: (character, tile_from, tile_to) ->
    1
