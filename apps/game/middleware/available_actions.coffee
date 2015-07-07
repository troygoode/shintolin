_ = require 'underscore'
BPromise = require 'bluebird'
data = require '../../../data'
actions = require '../../../data/actions'

calculate_actions = (character, tile) ->
  return BPromise.resolve([]) unless character? and tile?

  defaults = ->
    actions._default(character, tile)

  for_terrain = (terrain) ->
    return [] unless terrain?
    if terrain?.actions? and _.isFunction terrain.actions
      terrain.actions(character, tile)
    else if terrain?.actions?
      terrain.actions

  for_building = (building) ->
    return [] unless building?
    if building?.actions? and _.isFunction building.actions
      building.actions(character, tile)
    else if building?.actions?
      building.actions

  BPromise.all([
    defaults()
    for_terrain(data.terrains[tile.terrain])
    for_building(if tile.building? then data.buildings[tile.building] else null)
  ])
    .then _.flatten
    .then _.union

module.exports = (check_for_action) ->
  (req, res, next) ->
    BPromise.resolve()
      .then ->
        calculate_actions req.character, req.tile

      .tap (action_keys) ->
        if check_for_action and not _.contains(action_keys, check_for_action)
          throw "The action #{check_for_action} is not allowed here."

      .then (action_keys) ->
        hash = {}
        for key in action_keys
          hash[key] = if actions[key]? then actions[key](req.character, req.tile) else true
        BPromise.props hash

      .then (available_actions) ->
        req.actions = available_actions
        res.locals.actions = available_actions
        next()

      .catch (err) ->
        next err
