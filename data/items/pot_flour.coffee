module.exports =
  id: 'pot_flour'
  name: 'pot of flour'
  plural: 'pots of flour'
  weight: 7

  craft: (character, tile) ->
    takes:
      ap: 16
      skill: 'milling'
      items:
        wheat: 4
        pot: 1
    gives:
      items:
        pot_flour: 1
      xp:
        crafter: 5
