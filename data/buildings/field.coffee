BPromise = require 'bluebird'
time = require '../../time'
STARTING_HP = 4
MAX_OVERUSE = 24

module.exports =
  name: 'Field'
  size: 'small'
  hp: STARTING_HP
  hp_max: 200

  actions: (character, tile) ->
    BPromise.resolve switch time().season
      when 'Spring', 'Summer'
        if tile.hp <= STARTING_HP
          ['field_sow']
        else
          ['field_water']
      when 'Autumn'
        ['field_harvest']

  exterior: (character, tile) ->
    if tile.hp <= STARTING_HP
      'dirt'
    else
      '_exterior_field'

  build: (character, tile) ->
    validate: (cb) ->
      if time().season isnt 'Spring'
        cb('Fields can only be prepared in the spring.')
      else if tile.overuse > MAX_OVERUSE
        cb('This land has been overfarmed; no crops can be grown here until the land recovers.')
      else
        cb()
    takes:
      ap: 30
      tools: ['hoe']
      skill: 'agriculture'
    gives:
      xp:
        herbalist: 10

  text:
    built: 'It\'s tiring work, but you manage to turn over the soil in the area, leaving several furrows in which to plant crops. The newly ploughed soil is rich and fertile.'
