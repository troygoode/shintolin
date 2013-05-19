module.exports =
  id: 'tea'
  name: 'cup of herbal tea'
  takes: (character, tile) ->
    ap: 10
    building: 'campfire'
    items:
      thyme: 2
      bark: 2
  gives: (character, tile) ->
    items:
      tea: 1
    xp:
      herbalist: 5
      crafter: 1
