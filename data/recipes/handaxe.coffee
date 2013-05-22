module.exports =
  id: 'handaxe'
  name: 'hand axe'

  craft: (character, tile) ->
    takes:
      ap: 10
      tools: ['stone']
      items:
        flint: 1
    gives:
      items:
        handaxe: 1
      xp:
        crafter: 10
