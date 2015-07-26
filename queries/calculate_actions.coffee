_ = require 'underscore'
data = require '../data'

module.exports = (character, tile) ->
  actions = []

  # Terrain Actions
  terrain = if tile?.terrain then data.terrains[tile.terrain] else null
  if terrain?.actions? and _.isFunction terrain.actions
    actions = actions.concat terrain.actions(character, tile)
  else if terrain?.actions?
    actions = actions.concat terrain.actions

  # Building Actions
  building = if tile?.building then data.buildings[tile.building] else null
  if building?.actions? and _.isFunction building.actions
    actions = actions.concat building.actions(character, tile)
  else if building?.actions?
    actions = actions.concat building.actions

  _.uniq actions
