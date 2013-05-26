module.exports =
  id: 'shrine_fertiltiy'
  name: 'Fertiltiy Shrine'
  size: 'small'
  hp: 50
  interior: 'shrine_fertility_interior'
  upgrade: true
  actions: ['write']

  recovery: (character, tile) ->
    if tile.z is 1
      1
    else
      0

  build: (character, tile) ->
    takes:
      ap: 50
      building: 'hut'
      skill: 'divine_inspiration'
      items:
        water_pot: 3
        wheat: 10
        stone_sickle: 3
        poultice: 10
        tea: 10
    gives:
      xp:
        crafter: 50

  repair: (character, tile) ->
    max = @hp_max ? @hp
    return null unless tile.hp < max
    takes:
      ap: 10
      items:
        timber: 4
        water_pot: 1
        wheat: 3
        stone_sickle: 1
        poultice: 1
    gives:
      tile_hp: 5
      xp:
        crafter: 5

  text:
    built: 'Placing your offerings on a small altar, you ask for the blessings of the spirits of fertility. You sense that they are pleased with your gifts; this building is now a fertility shrine.'
