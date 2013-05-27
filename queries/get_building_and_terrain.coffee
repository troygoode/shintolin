_ = require 'underscore'
data = require '../data'
config = require '../config'
default_terrain = data.terrains[config.default_terrain]

module.exports = (character, tile) ->
  return building: null, terrain: default_terrain unless tile?

  # the building
  if tile?.building?
    building = data.buildings[tile.building]

  # the terrain
  if building?
    if _.isFunction building.exterior
      terrain = data.terrains[building.exterior(character, tile)]
    else
      terrain = data.terrains[building.exterior]
  else if tile.terrain?
    terrain = data.terrains[tile.terrain]

  building: building
  terrain: terrain ? default_terrain
