BPromise = require 'bluebird'
mw = require '../middleware'
charge_ap = BPromise.promisify(require '../../../commands/charge_ap')

module.exports = (app) ->
  app.post '/actions/:action_key', mw.available_actions(), (req, res, next) ->
    action = req.actions[req.params.action_key]
    action.execute(req.body, req, res, next)
      .then ->
        if action.ap?
          charge_ap req.character, action.ap
      .then ->
        res.redirect '/game'
      .catch (err) ->
        if typeof err is 'string'
          next err
        else if err.message?
          next err.message
        else
          next err
