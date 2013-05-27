_ = require 'underscore'

module.exports =
  id: 'river_rapids'
  style: 'rapids'

  describe: (tile) ->
    'You are wading through a rapid stream, tumbling down the hillside.'

  altitude: 1
  cost_to_enter: (character, tile_from, tile_to) ->
    if _.contains character.skills, 'swimming'
      7
    else
      null
