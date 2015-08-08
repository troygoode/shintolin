module.exports =
  name: 'Campfire'
  size: 'small'
  hp: 25
  hp_max: 30

  recovery: (character, tile) ->
    return 0 unless character.hp > 0
    .5

  build: (character, tile) ->
    takes:
      ap: 3
      items:
        stick: 4
    gives:
      xp:
        wanderer: 3

  repair: (character, tile) ->
    max = @hp_max ? @hp
    return null unless tile.hp < max
    takes:
      ap: 1
      items:
        stick: 1
    gives:
      tile_hp: 5
      xp:
        wanderer: 1

  text:
    built: 'You rub two sticks together, gradually heating them up. Eventually you produce a few embers, and soon there is a roaring fire in front of you.'
    hp: 'Intensity'
    repair:
      button: 'Add Fuel'
      success_you: 'throw a stick on the fire'
      success_nearby: 'threw a stick on the fire'
