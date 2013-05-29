module.exports =
  name: 'slice of huckleberry pie'
  plural: 'slices of huckleberry pie'
  tags: ['usable', 'food']
  weight: 1

  craft: (character, tile) ->
    takes:
      ap: 8
      building: 'bakery'
      skill: 'baking'
      items:
        pot_flour: 1
        pot_water: 1
        huckleberry: 3
    gives:
      items:
        huckleberry_pie: 15
        pot: 2
      xp:
        herbalist: 4
