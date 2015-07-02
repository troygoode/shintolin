moment = require 'moment'
data = require '../../../data'
queries = require '../../../queries'

module.exports = (router) ->
  router.get '/rankings', (req, res, next) ->
    queries.active_characters (err, active) ->
      return next(err) if err?
      res.locals.moment = moment
      res.locals.active = active
      res.locals.data = data
      switch req.param('metric')
        when 'frags'
          queries.rankings.frags (err, characters) ->
            res.render 'rankings', frags: characters
        when 'deaths'
          queries.rankings.deaths (err, characters) ->
            res.render 'rankings', deaths: characters
        when 'kills'
          queries.rankings.kills (err, characters) ->
            res.render 'rankings', kills: characters
        when 'revives'
          queries.rankings.revives (err, characters) ->
            res.render 'rankings', revives: characters
        when 'younguns'
          queries.rankings.younguns (err, characters) ->
            res.render 'rankings', younguns: characters
        when 'oldies'
          queries.rankings.oldies (err, characters) ->
            res.render 'rankings', oldies: characters
        when 'survival'
          queries.rankings.survival (err, characters) ->
            res.render 'rankings', survival: characters
        when 'oldtowns'
          queries.rankings.oldtowns (err, settlements) ->
            res.render 'rankings', oldtowns: settlements
        when 'newtowns'
          queries.rankings.newtowns (err, settlements) ->
            res.render 'rankings', newtowns: settlements
        when 'bigtowns'
          queries.rankings.bigtowns (err, settlements) ->
            res.render 'rankings', bigtowns: settlements
        else
          res.render 'rankings'
