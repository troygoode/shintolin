time = require '../../time'

module.exports =
  id: 'field'
  name: 'Field'
  size: 'small'
  hp: 4
  hp_max: 200

  actions: (character, tile) ->
    switch time().season
      when 'Spring', 'Summer'
        if tile.hp <= 4
          ['sow']
        else if not tile.watered
          ['water']
      when 'Autumn'
        ['harvest']

  exterior: (character, tile) ->
    if tile.hp <= 4
      'dirt'
    else
      'field'

  build: (character, tile) ->
    takes:
      ap: 30
      tools: ['digging_stick']
      skill: 'agriculture'
    gives:
      xp:
        herbalist: 10
