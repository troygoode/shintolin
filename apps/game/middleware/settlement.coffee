queries = require '../../../queries'

module.exports = (req, res, next) ->
  return next() unless req.tile?.settlement_id?
  queries.get_settlement req.tile.settlement_id.toString(), (err, settlement) ->
    return next(err) if err?
    req.settlement = settlement
    res.locals.settlement = settlement
    next()
