module.exports =
  name: 'plank of timber'
  plural: 'planks of timber'
  weight: 3

  craft: (character, tile) ->
    takes:
      ap: 12
      tools: ['stone_carpentry']
      skill: 'carpentry'
      items:
        log: 1
    gives:
      items:
        timber: 3
      xp:
        crafter: 5
