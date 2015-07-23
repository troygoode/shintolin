config = require '../config'
data = require '../data'
hunger_debuff = require './calculate_hunger_debuff'
MINIMUM_RECOVERY = 1

module.exports = (character, tile) ->
  recovery = config.ap_per_hour

  if character.hp <= 0
    recovery = MINIMUM_RECOVERY
  else
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

  recovery = MINIMUM_RECOVERY if recovery < MINIMUM_RECOVERY #minimum recovery
  return recovery
