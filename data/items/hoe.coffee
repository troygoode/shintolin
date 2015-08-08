module.exports =
  name: 'hoe'
  plural: 'hoes'

  weight: 1
  break_odds: .12

  craft: (character, tile) ->
    takes:
      ap: 5
      tools: ['axe_hand']
      skill: 'carpentry'
      items:
        stick: 1
      tags: ['carpentry:ap-reduction']
    gives:
      items:
        hoe: 1
      xp:
        crafter: 3
