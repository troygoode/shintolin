commands = require '../../../commands'
queries = require '../../../queries'

module.exports = (app) ->
  app.post '/leave', (req, res, next) ->
    return next('You don\'t belong to a settlement.') unless req.character.settlement_id?
    queries.get_settlement req.character.settlement_id.toString(), (err, settlement) ->
      return next(err) if err?
      commands.leave_settlement req.character, settlement, (err) ->
        return next(err) if err?
        res.redirect '/game'
