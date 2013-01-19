module.exports =
  id: 'hut'
  name: 'Hut'
  size: 'small'
  hp: 30
  interior: 'hut_interior'
  
  takes: (character, tile) ->
    ap: 40
    items:
      stick: 20
      staff: 5

  gives: (character, tile) ->
    xp:
      crafter: 25
