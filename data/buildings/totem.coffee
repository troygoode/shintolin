module.exports =
  id: 'totem'
  name: 'Totem Pole'
  size: 'small'
  hp: 30
  tags: ['no_storm_damage']
  actions: ['join', 'promote']

  build_handler: (req, res, next) ->
    res.redirect '/game/settle'

  build: (character, tile) ->
    takes:
      ap: 30
      items:
        log: 1

  repair: (character, tile) ->
    max = @hp_max ? @hp
    return null unless tile.hp < max
    takes:
      ap: 10
      items:
        log: 1
    gives:
      tile_hp: 5
      xp:
        crafter: 5
