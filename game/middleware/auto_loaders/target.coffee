queries = require '../../../queries'

module.exports = (req, res, next) ->
  target_id = req.param('target')
  return next() unless target_id?
  queries.get_character target_id, (err, target) ->
    return next(err) if err?
    return next('Target not present.') unless target.x is req.character.x and target.y is req.character.y and target.z is req.character.z
    req.target = target
    next()
