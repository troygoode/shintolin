moment = require 'moment'
queries = require '../../queries'

module.exports = (app) ->
  app.get '/rankings', (req, res, next) ->
    res.locals.moment = moment
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
        next() #TODO
      when 'newtowns'
        next() #TODO
      when 'bigtowns'
        next() #TODO
      else
        res.render 'rankings'
