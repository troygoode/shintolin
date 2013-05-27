time = require '../../time'

module.exports =
  id: 'cliff_bottom'
  style: 'grey'

  buildable: ['tiny']

  describe: (tile) ->
    'You are standing at the bottom of a cliff. Many large boulders, broken free from the rock face, are lying around.'

  search_odds: (tile, character) ->
    flint: .15
    huckleberry: .15
    stone: .10
