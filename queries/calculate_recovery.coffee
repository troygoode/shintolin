config = require '../config'
data = require '../data'
hunger_debuff = require './calculate_hunger_debuff'

module.exports = (character, tile) ->
  recovery = config.ap_per_hour

  # hunger debuff
  recovery += hunger_debuff character, tile

  # terrain bonus
  if tile?
    terrain = data.terrains[tile.terrain]
    if terrain.recovery?
      recovery += terrain.recovery(character, tile)
  else
    terrain = data.terrains[config.default_terrain]
    if terrain.recovery?
      recovery += terrain.recovery(character, tile)

  # building bonus
  if tile?.building?
    building = data.buildings[tile.building]
    if building.recovery?
      recovery += building.recovery(character, tile)

  recovery = 1 if recovery < 1 #minimum recovery
  return recovery
