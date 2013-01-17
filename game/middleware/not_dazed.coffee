module.exports = (req, res, next) ->
  return next() if req.character.hp > 0
  next 'You cannot do that while dazed.'
