queries = require '../../../queries'

module.exports = (app) ->
  app.get '/login', (req, res, next) ->
    res.render 'login',
      message: req.query.msg

  app.get '/reset-password', (req, res, next) ->
    res.render 'reset-password'

  app.post '/login', (req, res, next) ->
    queries.authorize req.body.email, req.body.password, (err, ok, character) ->
      return next(err) if err?
      return res.redirect('/login?msg=bad_pw') unless ok

      req.session.character = character._id.toString()
      req.session.email = character.email

      if character.developer
        req.session.developer = true
      else
        delete req.session.developer

      res.redirect '/game'
