config = require '../config'
data = require '../data'

module.exports = (character, tile) ->
  recovery = config.ap_per_hour
  if tile?
    terrain = data.terrains[tile.terrain]
    if terrain.recovery?
      recovery += terrain.recovery(character, tile)
  else
    terrain = data.terrains[config.default_terrain]
    if terrain.recovery?
      recovery += terrain.recovery(character, tile)
  if tile?.building?
    building = data.buildings[tile.building]
    if building.recovery?
      recovery += building.recovery(character, tile)
  recovery = 1 if recovery < 1
  return recovery
