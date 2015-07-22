_ = require 'underscore'
calculate_actions = require '../../queries/calculate_actions'
data = require '../'

module.exports = (character, tile) ->
  actions = calculate_actions character, tile
  terrain = if tile.terrain then data.terrains[tile.terrain] else null
  building = if tile.building then data.buildings[tile.building] else null

  # BUILD
  if tile.z is 0 and not tile.building?
    actions.push 'build'
  else if tile.z is 0 and tile.building?
    if building.upgradeable_to?
      actions.push 'build'

  # SEARCH
  unless _.contains(actions, 'take')
    actions.push 'search'

  # KICK OUT
  if tile.z isnt 0
    actions.push 'kick_out'

  actions
