_ = require 'underscore'

module.exports =
  style: 'rapids'
  block_spawning: true

  tags: ['freshwater', 'deep']

  describe: (tile) ->
    'You are wading through a rapid stream, tumbling down the hillside.'

  altitude: 1
  cost_to_enter: (character, tile_from, tile_to) ->
    if _.contains character.skills, 'swimming'
      7
    else
      null
