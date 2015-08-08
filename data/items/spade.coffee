module.exports =
  name: 'spade'
  plural: 'spades'

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
        spade: 1
      xp:
        crafter: 3
