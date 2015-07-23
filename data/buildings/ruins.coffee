module.exports =
  name: 'Ruins'
  size: 'small'
  exterior: '_exterior_ruins'
  interior: '_interior_ruins'
  invulnerable: true
  tags: ['no_storm_damage']

  recovery: (character, tile) ->
    return 0 unless character.hp > 0
    return 0 unless tile.z isnt 0
    .3

  build: (character, tile) ->
    takes:
      developer: true

  cost_to_enter: (character, tile_from, tile_to) ->
    1
