db = require '../../../db'
data = require '../../../data'
commands = require '../../../commands'
queries = require '../../../queries'
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

  app.post '/dev/move-random', developers_only, (req, res, next) ->
    queries.get_random_tile (err, tile) ->
      return next(err) if err?
      return next('NO_RANDOM_TILE_RETURNED') unless tile?._id?
      commands.teleport req.character, req.tile, tile, (err) ->
        return next(err) if err?
        res.redirect '/game'

  app.post '/dev/spawn', developers_only, (req, res, next) ->
    creature = data.creatures[req.body.creature]
    return next('Invalid Creature') unless creature?
    commands.create_creature creature, req.tile, (err) ->
      return next(err) if err?
      res.redirect '/game'

  app.post '/dev/paint', developers_only, (req, res, next) ->
    return next('Invalid Terrain') unless data.terrains[req.body.terrain]?
    if req.body.region?.length
      return next('Invalid Region') unless data.regions[req.body.region]?
    commands.paint req.tile, req.body.terrain, req.body.region, (err) ->
      return next(err) if err?
      res.redirect '/game'

  app.post '/dev/possess', developers_only, (req, res, next) ->
    return next('Invalid target.') unless req.target?
    return next('Cannot possess a building.') if req.target is 'building'
    req.session.possessor =
      character: req.session.character
      email: req.session.email
    req.session.character = req.target._id.toString()
    req.session.email = req.target.email
    res.redirect '/game'

  app.post '/dev/unpossess', developers_only, (req, res, next) ->
    return next('Not currently possessing anyone.') unless req.session.possessor?
    req.session.character = req.session.possessor.character
    req.session.email = req.session.possessor.email
    delete req.session.possessor
    res.redirect '/game'

  app.post '/dev/materialize', developers_only, (req, res, next) ->
    return next('Invalid item.') unless req.body.item?.length
    commands.give.items req.character, null, {item: req.body.item, count: parseInt(req.body.quantity ? 1)}, (err) ->
      return next(err) if err?
      res.redirect '/game'
