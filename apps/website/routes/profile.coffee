moment = require 'moment'
commands = require '../../../commands'
queries = require '../../../queries'

module.exports = (app) ->

  app.get '/profile/:character_slug', (req, res, next) ->
    queries.get_character_by_slug req.params.character_slug, (err, character) ->
      return next(err) if err?
      return next() unless character?
      res.render 'profile',
        message: req.query.msg
        moment: moment
        character: character
        editable: character._id.toString() is req.session.character

  app.post '/profile/:character_slug', (req, res, next) ->
    queries.get_character_by_slug req.params.character_slug, (err, character) ->
      return next(err) if err?
      return next() unless character?

      fail = (msg) ->
        res.redirect "/profile/#{character.slug}?msg=#{msg}"

      return next('Unauthorized') unless character._id.toString() is req.session.character
      return fail('no_email') if req.body.email?.length and not /^.+@.+\..+$/.test(req.body.email)
      commands.update_profile character, req.body.bio, req.body.image_url, req.body.email, req.body.password, (err) ->
        if err
          switch err
            when 'EMAIL_TAKEN' then fail('email_taken')
            else next(err)
        else
          res.redirect "/profile/#{character.slug}"
