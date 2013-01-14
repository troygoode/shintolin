queries = require '../../queries'

module.exports = (app) ->
  app.get '/', (req, res, next) ->
    queries.get_character req.session.character, (err, character) ->
      return next(err) if err?
      return res.redirect('/logout') unless character?
      res.render 'game',
        character: character
