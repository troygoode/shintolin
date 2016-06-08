Bluebird = require 'bluebird'
_ = require 'underscore'
moment = require 'moment'
marked = require 'marked'
data = require '../../../data'
commands = require '../../../commands'
queries = require '../../../queries'

get_character_by_slug = Bluebird.promisify(queries.get_character_by_slug)
get_settlement_p = Bluebird.promisify(queries.get_settlement)

get_settlement = (character) ->
  if character?.settlement_id?
    get_settlement_p character.settlement_id
  else
    null

module.exports = (app) ->

  app.get '/profile/:character_slug', (req, res, next) ->
    Bluebird.resolve()
      .then ->
        get_character_by_slug(req.params.character_slug)
      .then (character) ->
        return next() unless character?

        titles = {}
        for key of (character.badges ? {})
          badge = data.badges[key]
          if badge?.title
            titles[key] = badge

        Bluebird.props({
          settlement: get_settlement(character)
          hits: queries.hits_by_character(character)
        })
          .then ({settlement, hits}) ->
            res.render 'profile',
              _: _
              bio: marked(character.bio ? '')
              message: req.query.msg
              data: data
              moment: moment
              character: character
              settlement: settlement
              leader: settlement?.leader? and settlement.leader._id.toString() is character._id.toString()
              editable: character._id.toString() is req.session.character
              titles: titles
              hits: hits

      .catch (err) ->
        next(err)


  app.post '/profile/:character_slug', (req, res, next) ->
    queries.get_character_by_slug req.params.character_slug, (err, character) ->
      return next(err) if err?
      return next() unless character?

      fail = (msg) ->
        res.redirect "/profile/#{character.slug}?msg=#{msg}"

      return next('Unauthorized') unless character._id.toString() is req.session.character or req.session?.developer
      return fail('no_email') if req.body.email?.length and not /^.+@.+\..+$/.test(req.body.email)
      commands.update_profile character, req.body.bio, req.body.image_url, req.body.title, req.body.email, req.body.password, (err) ->
        if err
          switch err
            when 'EMAIL_TAKEN' then fail('email_taken')
            else next(err)
        else
          res.redirect "/profile/#{character.slug}"
