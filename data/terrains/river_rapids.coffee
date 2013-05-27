module.exports =
  id: 'river_rapids'
  style: 'rapids'

  describe: (tile) ->
    'You are wading through a rapid stream, tumbling down the hillside.'

  cost_to_enter: (character, tile_from, tile_to) ->
    if _.contains character.skills, 'swimming'
      8
    else
      null
