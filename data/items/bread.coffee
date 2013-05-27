module.exports =
  id: 'bread'
  name: 'flatbread'
  plural: 'flatbreads'
  weight: 1
  tags: ['food']

  craft: (character, tile) ->
    takes:
      ap: 8
      skill: 'baking'
      building: 'bakery'
      items:
        pot_flour: 1
        pot_water: 1
    gives:
      items:
        bread: 10
        pot: 2
      xp:
        crafter: 1
        herbalist: 4
