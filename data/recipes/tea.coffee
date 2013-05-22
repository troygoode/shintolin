module.exports =
  id: 'tea'
  name: 'cup of herbal tea'

  craft: (character, tile) ->
    takes:
      ap: 10
      building: 'campfire'
      items:
        thyme: 2
        bark: 2
    gives:
      items:
        tea: 1
      xp:
        herbalist: 5
        crafter: 1
