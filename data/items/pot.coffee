module.exports =
  name: 'pot'
  plural: 'pots'
  weight: 3

  craft: (character, tile) ->
    takes:
      ap: 10
      building: 'kiln'
      skill: 'pottery'
      items:
        clay: 3
    gives:
      items:
        pot: 1
      xp:
        crafter: 5
