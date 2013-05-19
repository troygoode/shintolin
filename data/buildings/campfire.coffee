module.exports =
  id: 'campfire'
  name: 'Campfire'
  size: 'small'
  hp: 30
  
  takes: (character, tile) ->
    ap: 10
    items:
      stick: 10

  gives: (character, tile) ->
    xp:
      wanderer: 5
