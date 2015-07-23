module.exports =
  name: 'Gate Foundation'
  size: 'large'
  hp: 40
  exterior: '_exterior_gate_open'
  upgradeable_to: 'gate'

  build: (character, tile) ->
    takes:
      ap: 50
      developer: true
      settlement: true
      skill: 'masonry'
      tools: ['masonry_tools']
      items:
        stone_block: 10
    gives:
      xp:
        crafter: 35

  repair: (character, tile) ->
    max = @hp_max ? @hp
    return null unless tile.hp < max
    takes:
      ap: 5
      items:
        stone_block: 2
    gives:
      tile_hp: 5
      xp:
        crafter: 1
