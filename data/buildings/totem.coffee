module.exports =
  id: 'totem'
  name: 'Totem Pole'
  size: 'small'
  hp: 30

  build: (character, tile) ->
    takes:
      ap: 30
      items:
        log: 1
    on: (req, res, next) ->
      res.redirect '/game/settle'
