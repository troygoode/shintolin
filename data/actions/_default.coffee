BPromise = require 'bluebird'

module.exports = (character, tile) ->
  actions = []

  if tile.z is 0 and not tile.building?
    actions.push 'build'

  actions.push 'search'

  actions
