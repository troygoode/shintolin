queries = require '../../queries'

module.exports = (app) ->
  app.get '/profile/:character_id', (req, res, next) ->
    queries.get_character req.param('character_id'), (err, character) ->
      return next(err) if err?
      return next() unless character?
      res.render 'profile', character: character
