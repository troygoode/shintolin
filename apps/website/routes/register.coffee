Bluebird = require 'bluebird'
fetch = require 'isomorphic-fetch'
FormData = require 'form-data'

commands = require '../../../commands'
queries = require '../../../queries'

get_character_by_email = Bluebird.promisify(queries.get_character_by_email)
get_character_by_name = Bluebird.promisify(queries.get_character_by_name)
get_settlement = Bluebird.promisify(queries.get_settlement)
create_character = Bluebird.promisify(commands.create_character)

module.exports = (app) ->
  app.post '/register', (req, res, next) ->
    Bluebird.resolve()
      # ReCAPTCHA
      .then ->
        return unless process.env.RECAPTCHA_SECRET?.length
        throw new Error('no_recaptcha') unless req.body['g-recaptcha-response']?.length
        data = new FormData()
        data.append('secret', process.env.RECAPTCHA_SECRET)
        data.append('response', req.body['g-recaptcha-response'])
        data.append('remoteip', req.ip)
        fetch('https://www.google.com/recaptcha/api/siteverify', {
          method: 'POST'
          body: data
        })
          .then (gres) ->
            gres.json()
          .then (gres) ->
            throw new Error('recaptcha_failed') unless gres.success is true

      # validate uniqueness
      .then ->
        Bluebird.props(
          by_email: get_character_by_email(req.body.email)
          by_name: get_character_by_name(req.body.username)
        )
      .then ({by_email, by_name}) ->
        throw new Error('email_taken') if by_email?
        throw new Error('name_taken') if by_name?

      # create character
      .then ->
        return unless req.body.settlement?.length
        get_settlement(req.body.settlement)
      .then (settlement) ->
        name = req.body.username
        email = req.body.email
        throw new Error('too_short') unless name?.length > 3
        throw new Error('too_long') unless name?.length < 21
        throw new Error('invalid_name') unless /^\w+$/.test name
        throw new Error('no_email') unless /^.+@.+\..+$/.test email
        throw new Error('pw_not_match') unless req.body.password is req.body.password_2
        create_character name, email, req.body.password, settlement

      # log in
      .then (character) ->
        throw new Error('No character created!') unless character?
        req.session.character = character._id.toString()
        req.session.email = character.email
        res.redirect '/game'

      .catch (err) ->
        res.redirect("/?msg=#{err.message}")
