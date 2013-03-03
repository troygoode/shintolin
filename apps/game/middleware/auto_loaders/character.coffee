queries = require '../../../../queries'

module.exports = (req, res, next) ->
  target_id = req.param('character')
  return next() unless target_id?.length
  queries.get_character target_id, (err, target) ->
    return next(err) if err?
    req.target = target
    next()
