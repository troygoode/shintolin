module.exports =
  name: 'Cave'
  size: 'small'
  exterior: '_exterior_cave'
  interior: '_interior_cave'
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
