bcrypt = require 'bcrypt'
commands = require '../../commands'
queries = require '../../queries'

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

          # if no settlement was found, don't join one
          settlement ?=
            _id: null
            x: 0
            y: 0

          now = new Date()
          hash = bcrypt.hashSync req.body.password_1, 12

          character =
            name: req.body.username
            x: settlement.x
            y: settlement.y
            z: 0
            hp: 50
            hp_max: 50
            ap: 100.0
            hunger: 9
            last_action: now

            craft_xp: 0
            warrior_xp: 0
            herbal_xp: 0
            wanderer_xp: 0

            email: req.body.email
            password: hash
            #donated: false #don't need to store
            #banned: false #don't need to store

            settlement: settlement._id
            settlement_joined: now

            kills: 0
            frags: 1
            deaths: 0
            revives: 0
            created: now
            last_revived: now

            bio: ''
            image_url: ''

          return fail('too_short') unless character.name?.length > 3
          return fail('too_long') unless character.name?.length < 21
          return fail('invalid_name') unless /^\w+$/.test character.name
          return fail('no_email') unless /^\w+@\w+\.\w+$/.test character.email
          return fail('pw_not_match') unless req.body.password_1 is req.body.password_2

          commands.create_character character, (err, character) ->
            return next(err) if err?
            return next('No character created!') unless character?

            req.session.character = character._id.toString()
            req.session.email = character.email

            res.redirect '/game'
