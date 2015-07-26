time = require '../../time'
define_loot_table = require '../../queries/loot_table_define'

module.exports =
  style: 'grey'
  block_spawning: true

  buildable: ['tiny']
  actions: ['quarry']

  describe: (tile) ->
    'You are standing at the bottom of a cliff. Many large boulders, broken free from the rock face, are lying around.'

  search_odds: (character, tile) ->
    define_loot_table character, tile,
      items:
        flint: .15
        huckleberry: .15
        stone: .10
