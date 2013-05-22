module.exports =
  id: 'poultice'
  name: 'herbal poultice'

  craft: (character, tile) ->
    takes:
      ap: 10
      items:
        thyme: 5
        bark: 2
    gives:
      items:
        poultice: 1
      xp:
        herbalist: 5
        crafter: 1
