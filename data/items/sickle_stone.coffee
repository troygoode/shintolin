module.exports =
  name: 'stone sickle'
  plural: 'stone sickles'
  tags: ['weapon', 'sickle', 'harvest', 'harvest+']
  weight: 2
  break_odds: .02

  craft: (character, tile) ->
    takes:
      ap: 10
      building: 'workshop'
      skill: 'carpentry'
      items:
        axe_hand: 1
        stick: 1
      tags: ['carpentry:ap-reduction']
    gives:
      items:
        sickle_stone: 1
      xp:
        crafter: 10
