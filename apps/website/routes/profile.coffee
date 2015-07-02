moment = require 'moment'
commands = require '../../../commands'
queries = require '../../../queries'

module.exports = (app) ->

  app.get '/profile/:character_slug', (req, res, next) ->
    queries.get_character_by_slug req.params.character_slug, (err, character) ->
      return next(err) if err?
      return next() unless character?
      res.render 'profile',
        moment: moment
        character: character
        editable: character._id.toString() is req.session.character

  app.post '/profile/:character_slug', (req, res, next) ->
    queries.get_character_by_slug req.params.character_slug, (err, character) ->
      return next(err) if err?
      return next() unless character?
      return next('Unauthorized') unless character._id.toString() is req.session.character
      commands.update_profile character, req.body.bio, req.body.image_url, req.body.password, (err) ->
        return next(err) if err?
        res.redirect "/profile/#{character.slug}"
