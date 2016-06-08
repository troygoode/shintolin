Bluebird = require 'bluebird'
_ = require 'underscore'
queries = require '../../../queries'

get_character = Bluebird.promisify(queries.get_character)

module.exports = (app) ->

  app.get '/ip/:ip', (req, res, next) ->
    return next() unless req.session?.developer

    Bluebird.resolve()
      .then ->
        queries.hits_by_ip req.params.ip
      .then (hits) ->

        character_ids = _.chain(hits).pluck('character').uniq().value()
        Bluebird.resolve(character_ids)
          .map (id) -> get_character(id)
          .then (characters) ->

            lookup = {}
            for c in characters
              if c?._id?
                lookup[c._id.toString()] =
                  name: c.name
                  slug: c.slug

            res.render 'ip',
              ip: req.params.ip
              hits: hits
              characters: lookup

      .catch next
