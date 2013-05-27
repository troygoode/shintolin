time = require '../../time'

module.exports =
  id: 'cliff_face'
  style: 'rshore'

  describe: (tile) ->
    'You are clinging to the side of a cliff, at low elevation.'

  cost_to_enter: (character, tile_from, tile_to) ->
    if _.contains character.skills, 'mountaineering'
      4
    else
      null
