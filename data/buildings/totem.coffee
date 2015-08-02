_ = require 'underscore'

module.exports =
  name: 'Totem Pole'
  size: 'small'
  hp: 30
  tags: ['no_storm_damage']
  actions: ['settlement_join']

  build_handler: (req, res, next) ->
    if _.contains req.character.skills, 'settling'
      res.redirect '/game/settle'
    else
      next 'The \'settling\' skill is required to do that.'

  build: (character, tile) ->
    takes:
      ap: 30
      skill: 'settling'
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
