module.exports =
  name: 'set of stone carpentry tools'
  plural: 'sets of stone carpentry tools'
  tags: ['write']
  weight: 8

  break_odds: .04

  craft: (character, tile) ->
    takes:
      ap: 15
      skill: 'carpentry'
      items:
        axe_hand: 4
        stick: 4
      tags: ['carpentry:ap-reduction']
    gives:
      items:
        stone_carpentry: 1
      xp:
        crafter: 15
