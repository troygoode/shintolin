_ = require 'underscore'
Bluebird = require 'bluebird'
calculate_actions = require '../../queries/calculate_actions'
data = require '../'

module.exports = (character, tile) ->
  Bluebird.resolve()
    .then ->
      calculate_actions character, tile
    .then (actions) ->

      terrain = if tile?.terrain then data.terrains[tile.terrain] else null
      building = if tile?.building then data.buildings[tile.building] else null

      if tile?

        # BUILD
        if tile.z is 0 and not tile.building?
          actions.push 'build'
        else if tile.z is 0 and tile.building?
          if building.upgradeable_to?
            actions.push 'build'

        # KICK OUT
        if tile.z isnt 0
          actions.push 'kick_out'

        if tile.building?
          actions.push 'repair'

      # SEARCH
      unless _.contains(actions, 'take')
        actions.push 'search'

      # ATTACK (OTHER PLAYERS) & ATTACK (BUILDING)
      actions.push 'attack_building'
      actions.push 'attack_player'

      # USE (OTHER PLAYERS) & USE (SELF)
      actions.push 'use_player'
      actions.push 'use_self'

      # CRAFT
      actions.push 'craft'

      # DROP
      actions.push 'drop'

      # GIVE (OTHER PLAYERS)
      actions.push 'give_player'

      # REVIVE (SELF)
      if character.revivable?
        actions.push 'revive_self'

      actions
