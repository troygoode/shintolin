module.exports =
  id: 'hospital'
  name: 'Hospital'
  size: 'large'
  hp: 50
  interior: '_interior_hospital'
  upgrade: true
  actions: ['write']

  build: (character, tile) ->
    takes:
      ap: 25
      settlement: true
      building: 'longhouse'
      skill: 'hospitaller'
      items:
        thyme: 7
        bark: 7
        poultice: 7
    gives:
      xp:
        crafter: 25

  repair: (character, tile) ->
    max = @hp_max ? @hp
    return null unless tile.hp < max
    takes:
      ap: 10
      items:
        thyme: 2
        bark: 2
        poultice: 2
    gives:
      tile_hp: 5
      xp:
        crafter: 5

  text:
    built: 'You organise your medicinal supplies and establish a hospital in this building.'
