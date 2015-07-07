mw = require '../middleware'

module.exports = (app) ->
  app.post '/actions/:action_key', mw.available_actions(), (req, res, next) ->
    action = req.actions[req.params.action_key]
    action.execute(req.body, req, res, next)
      .then ->
        res.redirect '/game'
      .catch (err) ->
        next err.message
