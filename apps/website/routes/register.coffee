commands = require '../../../commands'
queries = require '../../../queries'

module.exports = (app) ->
  app.post '/register', (req, res, next) ->
    fail = (msg) ->
      res.redirect("/?msg=#{msg}")

    queries.get_character_by_email req.body.email, (err, character) ->
      return next(err) if err?
      return fail('email_taken') if character?
      queries.get_character_by_name req.body.name, (err, character) ->
        return next(err) if err?
        return fail('name_taken') if character?
        queries.get_settlement req.body.settlement, (err, settlement) ->
          return next(err) if err?

          name = req.body.username
          email = req.body.email

          return fail('too_short') unless name?.length > 3
          return fail('too_long') unless name?.length < 21
          return fail('invalid_name') unless /^\w+$/.test name
          return fail('no_email') unless /^.+@.+\..+$/.test email
          return fail('pw_not_match') unless req.body.password_1 is req.body.password_2

          commands.create_character name, email, req.body.password_1, settlement, (err, character) ->
            return next(err) if err?
            return next('No character created!') unless character?

            req.session.character = character._id.toString()
            req.session.email = character.email

            res.redirect '/game'
