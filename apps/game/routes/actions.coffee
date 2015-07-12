BPromise = require 'bluebird'
mw = require '../middleware'
charge_ap = BPromise.promisify(require '../../../commands/charge_ap')

module.exports = (app) ->
  app.post '/actions/:action_key', mw.available_actions(), (req, res, next) ->
    action = req.actions[req.params.action_key]
    BPromise.resolve()
      .then ->
        throw 'You cannot do that while dazed.' if req.character.hp is 0
        throw 'You don\'t have enough AP.' if action.ap? and req.character.ap < action.ap
      .then ->
        action.execute(req.body, req, res, next)
      .then ->
        charge_ap(req.character, action.ap) if action.ap?
      .then ->
        res.redirect '/game'
      .catch (err) ->
        if typeof err is 'string'
          next err
        else if err.message?
          next err.message
        else
          next err
