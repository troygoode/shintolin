_ = require 'underscore'
walls_connect_to = ['wall', 'gate', 'guardstand']

module.exports =
  id: 'gate'
  name: 'Gate'
  size: 'large'
  hp: 70
  upgrade: true
  exterior: 'gate'

  recovery: (character, tile) ->
    -100000000

  build: (character, tile) ->
    takes:
      ap: 50
      settlement: true
      building: 'gate_pre'
      skill: 'construction'
      tools: ['stone_carpentry']
      items:
        timber: 16
    gives:
      xp:
        crafter: 35

  repair: (character, tile) ->
    max = @hp_max ? @hp
    return null unless tile.hp < max
    takes:
      ap: 20
      items:
        timber: 8
    gives:
      tile_hp: 10
      xp:
        crafter: 1

  cost_to_enter: (character, tile_from, tile_to) ->
    if character.settlement_id?.toString() is tile_to?.settlement_id?.toString()
      4
    else if tile_from?.building? and _.contains walls_connect_to, tile_from.building
      4
    else
      49
