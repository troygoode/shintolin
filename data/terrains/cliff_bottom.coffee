time = require '../../time'

module.exports =
  style: 'grey'

  buildable: ['tiny']
  actions: ['quarry']

  describe: (tile) ->
    'You are standing at the bottom of a cliff. Many large boulders, broken free from the rock face, are lying around.'

  search_odds: (character, tile) ->
    flint: .15
    huckleberry: .15
    stone: .10
