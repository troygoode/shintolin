_ = require 'underscore'
data = require '../data'
get_building_and_terrain = require './get_building_and_terrain'
MAX_WEIGHT = 70

module.exports = (character, from_tile, to_tile) ->
  from = get_building_and_terrain character, from_tile
  to = get_building_and_terrain character, to_tile

  ap_cost = 1
  if from.building?.cost_to_exit?
    extra = from.building.cost_to_exit(character, from_tile, to_tile, from.terrain, to.terrain)
    return null unless extra?
    ap_cost += extra
  if from.terrain.cost_to_exit?
    extra = from.terrain.cost_to_exit(character, from_tile, to_tile, from.terrain, to.terrain)
    return null unless extra?
    ap_cost += extra
  if to.terrain.cost_to_enter?
    extra = to.terrain.cost_to_enter(character, from_tile, to_tile, from.terrain, to.terrain)
    return null unless extra?
    ap_cost += extra
  if to.building?.cost_to_enter?
    extra = to.building.cost_to_enter(character, from_tile, to_tile, from.terrain, to.terrain)
    return null unless extra?
    ap_cost += extra

  if ap_cost < .5
    ap_cost = .5
  else
    .5

  if character.weight > MAX_WEIGHT
    ap_cost = ap_cost * 2

  ap_cost
