module.exports =
  id: 'campfire'
  name: 'Campfire'
  size: 'small'
  hp: 30

  recovery: (character, tile) ->
    .3
  
  takes: (character, tile) ->
    ap: 10
    items:
      stick: 10

  gives: (character, tile) ->
    xp:
      wanderer: 5
