module.exports =
  id: 'handaxe'
  name: 'hand axe'
  takes: (character, tile) ->
    ap: 10
    tools: ['stone']
    items:
      flint: 1
  gives: (character, tile) ->
    items:
      handaxe: 1
    xp:
      crafter: 10
