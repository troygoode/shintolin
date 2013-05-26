module.exports =
  id: 'stonemasonry'
  name: 'Stonemasonry'
  size: 'large'
  hp: 50
  interior: 'stonemasonry_interior'
  upgrade: true
  actions: ['write']

  build: (character, tile) ->
    takes:
      ap: 35
      settlement: true
      building: 'workshop'
      skill: 'masonry'
      items:
        boulder: 2
        stone: 6
        masonry_tools: 4
    gives:
      xp:
        crafter: 25

  repair: (character, tile) ->
    max = @hp_max ? @hp
    return null unless tile.hp < max
    takes:
      ap: 10
      items:
        boulder: 2
    gives:
      tile_hp: 5
      xp:
        crafter: 5

  text:
    built: 'You assemble work benches and organise your tools, setting up a stonemasonry in this building.'
