db = require '../../../db'
data = require '../../../data'
commands = require '../../../commands'
mw = require '../middleware'

developers_only = (req, res, next) ->
  if req.session.developer
    next()
  else
    res.send('Only developers may access that feature.')

module.exports = (app) ->

  app.get '/dev/replenish-ap', developers_only, (req, res, next) ->
    query =
      _id: req.character._id
    update =
      $set:
        ap: 100
    db.characters.update query, update, (err) ->
      return next(err) if err?
      res.redirect '/game'

  app.get '/dev/replenish-hp', developers_only, (req, res, next) ->
    query =
      _id: req.character._id
    update =
      $set:
        hp: 50
    db.characters.update query, update, (err) ->
      return next(err) if err?
      res.redirect '/game'

  app.post '/dev/paint', developers_only, (req, res, next) ->
    return next('Invalid Terrain') unless data.terrains[req.body.terrain]?
    return next('Invalid Region') unless data.regions[req.body.region]?
    commands.paint req.tile, req.body.terrain, req.body.region, (err) ->
      return next(err) if err?
      res.redirect '/game'

  app.post '/dev/possess', developers_only, (req, res, next) ->
    return next('Invalid target.') unless req.target?
    return next('Cannot possess a building.') if req.target is 'building'
    req.session.character = req.target._id.toString()
    req.session.email = req.target.email
    res.redirect '/game'

  app.post '/dev/materialize', developers_only, (req, res, next) ->
    return next('Invalid item.') unless req.body.item?.length
    commands.add_item req.character, data.items[req.body.item], parseInt(req.body.quantity ? 1), (err) ->
      return next(err) if err?
      res.redirect '/game'
