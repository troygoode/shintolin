module.exports =
  name: 'ocarina'
  plural: 'ocarinas'
  weight: 1
  tags: ['usable', 'ocarina']

  break_odds: .02

  craft: (character, tile) ->
    takes:
      ap: 7
      skill: 'pottery'
      building: 'kiln'
      items:
        clay: 1
    gives:
      items:
        ocarina: 1
      xp:
        crafter: 5
