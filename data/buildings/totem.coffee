module.exports =
  id: 'totem'
  name: 'Totem Pole'
  size: 'small'
  hp: 30

  takes: (character, tile) ->
    ap: 30
    items:
      log: 1

  build: (req, res, next) ->
    res.redirect '/game/settle'
