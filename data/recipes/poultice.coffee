module.exports =
  id: 'poultice'
  name: 'poultice'
  takes: (character, tile) ->
    ap: 10
    items:
      thyme: 5
      bark: 2
  gives: (character, tile) ->
    items:
      poultice: 1
    xp:
      herbalist: 5
      crafter: 1
