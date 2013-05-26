module.exports =
  id: 'trail'
  name: 'Trail'
  size: 'tiny'
  hp: 3

  build: (character, tile) ->
    takes:
      ap: 20
      tools: ['digging_stick']
    gives:
      xp:
        wanderer: 12

  repair: (character, tile) ->
    max = @hp_max ? @hp
    return null unless tile.hp < max
    takes:
      ap: 10
    gives:
      tile_hp: 1
      xp:
        wanderer: 1

  text:
    built: 'It\'s tiring work, but you manage to remove the turf in the area, leaving a dirt track.'
