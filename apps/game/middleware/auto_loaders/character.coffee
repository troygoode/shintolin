queries = require '../../../../queries'

module.exports = (req, res, next) ->
  target_id = req.body.character
  return next() unless target_id?.length
  if target_id is 'self'
    req.target = req.character
    next()
  else
    queries.get_character target_id, (err, target) ->
      return next(err) if err?
      req.target = target
      next()
