module.exports =
  id: 'field'
  name: 'Field'
  size: 'small'
  hp: 4

  build: (character, tile) ->
    takes:
      ap: 30
      tools: ['digging_stick']
      skill: 'agriculture'
    gives:
      xp:
        herbalist: 10
