_ = require 'underscore'
Bluebird = require 'bluebird'
{terrains, buildings} = require '../data'

module.exports = (character, tile) ->

  get_terrain_actions = ->
    # Terrain Actions
    terrain = if tile?.terrain then terrains[tile.terrain] else null
    if terrain?.actions? and _.isFunction terrain.actions
      terrain.actions(character, tile)
    else if terrain?.actions?
      terrain.actions

  get_building_actions = ->
    building = if tile?.building then buildings[tile.building] else null
    if building?.actions? and _.isFunction building.actions
      building.actions(character, tile)
    else if building?.actions?
      building.actions

  Bluebird.resolve()
    .then ->
      Bluebird.all [
        get_terrain_actions()
        get_building_actions()
      ]
    .then (actions) ->
      _.chain(actions).flatten().uniq().value().filter (action) ->
        action?
