config = require '../config'
data = require '../data'
MAX_HUNGER = 12
MAX_HUNGER_DEBUFF = 2.0

module.exports = (character, tile) ->
  recovery = config.ap_per_hour

  # hunger debuff
  hunger = (MAX_HUNGER - character.hunger)
  hunger_debuff = MAX_HUNGER_DEBUFF * (hunger / MAX_HUNGER)
  recovery -= hunger_debuff

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
