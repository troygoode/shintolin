module.exports =
  name: 'herbal poultice'
  plural: 'herbal poultices'
  tags: ['usable', 'revive']
  weight: 0

  amount_to_heal: 5

  craft: (character, tile) ->
    takes:
      ap: 10
      items:
        thyme: 5
        bark: 2
    gives:
      items:
        poultice: 1
      xp:
        herbalist: 5
        crafter: 1
