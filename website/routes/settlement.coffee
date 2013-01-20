queries = require '../../queries'

module.exports = (app) ->
  app.get '/settlements/:settlement_slug', (req, res, next) ->
    queries.get_settlement_by_slug req.param('settlement_slug'), (err, settlement) ->
      return next(err) if err?
      return next() unless settlement?
      res.render 'settlement', settlement: settlement
