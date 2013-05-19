db = require '../../../db'
data = require '../../../data'
commands = require '../../../commands'
mw = require '../middleware'

#TODO: secure

module.exports = (app) ->

  app.get '/debug/replenish-ap', (req, res, next) ->
    query =
      _id: req.character._id
    update =
      $set:
        ap: 100
    db.characters.update query, update, (err) ->
      return next(err) if err?
      res.redirect '/game'

  app.get '/debug/replenish-hp', (req, res, next) ->
    query =
      _id: req.character._id
    update =
      $set:
        hp: 50
    db.characters.update query, update, (err) ->
      return next(err) if err?
      res.redirect '/game'

  app.post '/debug/paint', (req, res, next) ->
    commands.paint req.tile, req.body.terrain, (err) ->
      return next(err) if err?
      res.redirect '/game'

  app.post '/debug/possess', (req, res, next) ->
    return next('Invalid target.') unless req.target?
    return next('Cannot possess a building.') if req.target is 'building'
    req.session.character = req.target._id.toString()
    req.session.email = req.target.email
    res.redirect '/game'

  app.post '/debug/materialize', (req, res, next) ->
    return next('Invalid item.') unless req.body.item?.length
    commands.add_item req.character, data.items[req.body.item], 1, (err) ->
      return next(err) if err?
      res.redirect '/game'
