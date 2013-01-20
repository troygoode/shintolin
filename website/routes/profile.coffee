queries = require '../../queries'

module.exports = (app) ->
  app.get '/profile/:character_slug', (req, res, next) ->
    queries.get_character_by_slug req.param('character_slug'), (err, character) ->
      return next(err) if err?
      return next() unless character?
      res.render 'profile', character: character
