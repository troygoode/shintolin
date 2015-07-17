MAX_HUNGER = 12
MAX_HUNGER_DEBUFF = 2.0
HUNGER_GRACE_PERIOD = 3.0

module.exports = (character, tile) ->
  recovery = 0

  # hunger debuff
  hunger = (MAX_HUNGER - character.hunger)
  if hunger > HUNGER_GRACE_PERIOD
    hunger_debuff = MAX_HUNGER_DEBUFF * (hunger / MAX_HUNGER)
    recovery -= hunger_debuff

  recovery
