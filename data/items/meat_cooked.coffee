module.exports =
  id: 'meat_cooked'
  name: 'hunk of cooked meat'
  plural: 'hunks of cooked meat'
  tags: ['food']
  weight: 1

  craft: (character, tile) ->
    takes:
      ap: 1
      building: 'campfire'
      items:
        meat_raw: 1
    gives:
      items:
        meat_cooked: 1
      xp:
        wanderer: 1
