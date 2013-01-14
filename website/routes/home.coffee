queries = require '../../queries'

module.exports = (app) ->
  app.get '/', (req, res, next) ->
    queries.settlements (err, settlements) ->
      return next(err) if err?
      queries.squares (err, squares) ->
        return next(err) if err?
        res.render 'home',
          message: req.param('msg')
          settlements: settlements
          squares: squares
          server_time: new Date()
