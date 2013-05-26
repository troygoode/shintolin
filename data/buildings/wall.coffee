_ = require 'underscore'
walls_connect_to = ['wall', 'gate', 'guardstand']

module.exports =
  id: 'wall'
  name: 'Wall'
  size: 'tiny'
  hp: 80
  exterior: '_exterior_wall'
  actions: ['write']
  tags: ['reduced_storm_damage']

  recovery: (character, tile) ->
    -100000000

  build: (character, tile) ->
    takes:
      ap: 50
      settlement: true
      skill: 'masonry'
      tools: ['masonry_tools']
      items:
        stone_block: 8
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
      tile_hp: 10
      xp:
        crafter: 10

  cost_to_enter: (character, tile_from, tile_to) ->
    if tile_from?.building? and _.contains walls_connect_to, tile_from.building
      4
    else
      69
