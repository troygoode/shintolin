BPromise = require 'bluebird'
data = require '../'

module.exports = (character, tile) ->
  actions = []

  if tile.z is 0 and not tile.building?
    actions.push 'build'
  else if tile.z is 0 and tile.building?
    building = data.buildings[tile.building]
    if building.upgradeable_to?
      actions.push 'build'

  actions.push 'search'

  if tile.z isnt 0
    actions.push 'kick_out'

  actions
