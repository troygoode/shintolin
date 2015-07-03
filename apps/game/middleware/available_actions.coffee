_ = require 'underscore'
data = require '../../../data'

calculate_actions = (character, tile) ->
  return null unless character? and tile?

  terrain = data.terrains[tile.terrain]
  building = data.buildings[tile.building] if tile.building?

  actions = []
  if terrain?.actions? and _.isFunction terrain.actions
    actions = _.union actions, terrain.actions(character, tile)
  else if terrain?.actions?
    actions = _.union actions, terrain.actions
  if building?.actions? and _.isFunction building.actions
    actions = _.union actions, building.actions(character, tile)
  else if building?.actions?
    actions = _.union actions, building.actions

  actions

module.exports = (check_for_action) ->
  (req, res, next) ->
    actions = calculate_actions req.character, req.tile
    if check_for_action
      return next("The action #{check_for_action} is not allowed here.") unless actions? and _.contains(actions, check_for_action)
    req.actions = actions
    res.locals.actions = actions
    next()
