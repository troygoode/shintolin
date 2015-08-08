Bluebird = require 'bluebird'
calculate_actions = require '../../queries/calculate_actions'

module.exports = (character, tile) ->
  Bluebird.resolve()
    .then ->
      calculate_actions character, tile
    .then (actions) ->
      actions.concat [
        'attack_building'
        'attack_player'
        'build'
        'craft'
        'drop'
        'give_player'
        'kick_out'
        'repair'
        'revive_self'
        'search'
        'use_player'
        'use_self'
      ]
