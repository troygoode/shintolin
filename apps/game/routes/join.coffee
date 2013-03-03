commands = require '../../../commands'
queries = require '../../../queries'
mw = require '../middleware'

module.exports = (app) ->
  app.post '/join', mw.not_dazed, mw.ap(25), (req, res, next) ->
    return next('Invalid Settlement') unless req.tile.settlement_id?
    return next('Must join from a totem.') unless req.tile.building is 'totem'
    return next('You already belong to a settlement.') if req.character.settlement_id?
    queries.get_settlement req.tile.settlement_id.toString(), (err, settlement) ->
      return next(err) if err?
      commands.join_settlement req.character, settlement, (err) ->
        return next(err) if err?
        res.redirect '/game'
