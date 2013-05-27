data = require '../data'
config = require '../config'
default_terrain = data.terrains[config.default_terrain]

module.exports = (character, old_tile, new_tile) ->
  old_terrain = data.terrains[old_tile.terrain]
  if new_tile?.terrain?
    new_terrain = data.terrains[new_tile.terrain]
  else
    new_terrain = default_terrain

  if old_tile.building?
    old_building = data.buildings[old_tile.building]
  if new_tile?.building?
    new_building = data.buildings[new_tile.building]

  ap_cost = 1
  if old_building?.cost_to_exit?
    extra = old_building.cost_to_exit(character, old_tile, new_tile, old_terrain, new_terrain)
    return null unless extra?
    ap_cost += extra
  if old_terrain.cost_to_exit?
    extra = old_terrain.cost_to_exit(character, old_tile, new_tile, old_terrain, new_terrain)
    return null unless extra?
    ap_cost += extra
  if new_terrain?.cost_to_enter?
    extra = new_terrain.cost_to_enter(character, old_tile, new_tile, old_terrain, new_terrain)
    return null unless extra?
    ap_cost += extra
  if new_building?.cost_to_enter?
    extra = new_building.cost_to_enter(character, old_tile, new_tile, old_terrain, new_terrain)
    return null unless extra?
    ap_cost += extra

  if ap_cost >= .5
    ap_cost
  else
    .5
