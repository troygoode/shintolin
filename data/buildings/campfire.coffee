module.exports =
  id: 'campfire'
  name: 'Campfire'
  size: 'small'
  hp: 30

  recovery: (character, tile) ->
    .3

  build: (character, tile) ->
    takes:
      ap: 10
      items:
        stick: 10
    gives:
      xp:
        wanderer: 5
