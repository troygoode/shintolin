module.exports =
  name: 'Stockpile'
  size: 'small'
  hp: 10
  actions: ['take', 'give', 'write']

  build: (character, tile) ->
    takes:
      ap: 10
      settlement: true
      items:
        stone: 8
    gives:
      xp:
        wanderer: 10

  repair: (character, tile) ->
    max = @hp_max ? @hp
    return null unless tile.hp < max
    takes:
      ap: 5
      items:
        stone: 1
    gives:
      tile_hp: 5
      xp:
        wanderer: 3

  text:
    built: 'You stake out a stockpile on the ground.'
