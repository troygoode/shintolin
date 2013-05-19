queries = require '../../../../queries'

module.exports = (req, res, next) ->
  target_id = req.param('target')
  return next() unless target_id?.length
  if target_id is 'building'
    req.target = 'building'
    next()
  else
    if target_id is 'self'
      req.target = req.character
      next()
    else
      queries.get_character target_id, (err, target) ->
        return next(err) if err?
        return next('Target not present.') unless target.x is req.character.x and target.y is req.character.y and target.z is req.character.z
        req.target = target
        next()
