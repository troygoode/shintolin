bcrypt = require 'bcrypt'
queries = require '../../queries'

module.exports = (app) ->
  app.post '/login', (req, res, next) ->
    hash = bcrypt.hashSync req.body.password, 12
    queries.authorize req.body.name, hash, (err, character) ->
      return next(err) if err?
      return res.redirect('/?msg=bad_pw') unless character?

      req.session.character = character._id.toString()
      req.session.email = character.email

      res.redirect '/game'
