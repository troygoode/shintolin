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
    validate: (cb) ->
      if time().season isnt 'Spring'
        cb('Fields can only be prepared in the spring.')
      else if tile.overuse > 24
        cb('This land has been overfarmed; no crops can be grown here until the land recovers.')
      else
        cb()
    takes:
      ap: 30
      tools: ['digging_stick']
      skill: 'agriculture'
    gives:
      xp:
        herbalist: 10
