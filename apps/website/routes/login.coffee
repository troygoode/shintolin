queries = require '../../../queries'

module.exports = (app) ->
  app.post '/login', (req, res, next) ->
    queries.authorize req.body.username, req.body.password, (err, ok, character) ->
      return next(err) if err?
      return res.redirect('/?msg=bad_pw') unless ok

      req.session.character = character._id.toString()
      req.session.email = character.email

      res.redirect '/game'
