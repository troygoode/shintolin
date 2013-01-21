commands = require '../../commands'
queries = require '../../queries'
mw = require '../middleware'

module.exports = (app) ->
  app.post '/vote', mw.ap(1), (req, res, next) ->
    return next('Invalid Settlement') unless req.tile.settlement_id?
    return next('Must join from a totem.') unless req.tile.building is 'totem'
    return next('You don\'t belong to this settlement.') if req.character.settlement_id?.toString() isnt req.tile.settlement_id.toString()
    return next('You cannot vote for them.') unless not req.target? or req.target?.settlement_id?.toString() is req.tile.settlement_id.toString()
    queries.get_settlement req.tile.settlement_id.toString(), (err, settlement) ->
      return next(err) if err?
      commands.vote_for settlement, req.character, req.target, (err) ->
        return next(err) if err?
        res.redirect '/game'
