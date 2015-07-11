config = require '../../../config'
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

  app.get '/dev', (req, res, next) ->
    res.render 'dev',
      config: config
      building: if req.tile.building then data.buildings[req.tile.building] else undefined
      center:
        terrain: data.terrains[req.tile.terrain]
        tile: req.tile
        people: req.tile.people?.filter (p) ->
          not p.creature? and p._id.toString() isnt req.character._id.toString()
      data: data
      possessor: req.session.possessor

  app.get '/dev/replenish-ap', developers_only, (req, res, next) ->
    query =
      _id: req.character._id
    update =
      $set:
        ap: 100
    db.characters.update query, update, (err) ->
      return next(err) if err?
      res.redirect '/game/dev'

  app.post '/dev/destroy', developers_only, (req, res, next) ->
    commands.destroy_building req.character, req.tile, (err) ->
      return next(err) if err?
      res.redirect '/game/dev'

  app.post '/dev/remove-player/:character_slug', developers_only, (req, res, next) ->
    queries.get_character_by_slug req.params.character_slug, (err, player) ->
      return next(err) if err?
      return next('Unknown Player') unless player?
      commands.remove_player player, (err) ->
        return next(err) if err?
        res.redirect '/rankings?metric=younguns'

  app.get '/dev/replenish-hp', developers_only, (req, res, next) ->
    query =
      _id: req.character._id
    update =
      $set:
        hp: 50
    db.characters.update query, update, (err) ->
      return next(err) if err?
      res.redirect '/game/dev'

  app.post '/dev/announce', developers_only, (req, res, next) ->
    commands.announce req.body.text, (err) ->
      return next(err) if err?
      res.redirect '/game/dev'

  app.post '/dev/teleport-to-coords', developers_only, (req, res, next) ->
    commands.teleport req.character, req.tile, {x: parseInt(req.body.x), y: parseInt(req.body.y), z: 0}, (err) ->
      return next(err) if err?
      res.redirect '/game/dev'

  app.post '/dev/teleport-to-character', developers_only, (req, res, next) ->
    return next('Invalid target.') unless req.body.target_name?
    queries.get_character_by_name req.body.target_name, (err, target) ->
      return next(err) if err?
      return next('Invalid target.') unless target?
      commands.teleport req.character, req.tile, {x: target.x, y: target.y, z: target.z}, (err) ->
        return next(err) if err?
        res.redirect '/game/dev'

  app.post '/dev/teleport-to-random-tile', developers_only, (req, res, next) ->
    queries.get_random_spawnable_tile (err, tile) ->
      return next(err) if err?
      return next('NO_RANDOM_TILE_RETURNED') unless tile?._id?
      commands.teleport req.character, req.tile, tile, (err) ->
        return next(err) if err?
        res.redirect '/game/dev'

  app.post '/dev/spawn', developers_only, (req, res, next) ->
    creature = data.creatures[req.body.creature]
    return next('Invalid Creature') unless creature?
    commands.create_creature creature, req.tile, (err) ->
      return next(err) if err?
      res.redirect '/game/dev'

  app.post '/dev/paint', developers_only, (req, res, next) ->
    return next('Invalid Terrain') unless data.terrains[req.body.terrain]?
    if req.body.region?.length
      return next('Invalid Region') unless data.regions[req.body.region]?
    commands.paint req.tile, req.body.terrain, req.body.region, (err) ->
      return next(err) if err?
      res.redirect '/game/dev'

  app.post '/dev/possess', developers_only, (req, res, next) ->
    return next('Invalid target.') unless req.target?
    return next('Cannot possess a building.') if req.target is 'building'
    req.session.possessor =
      character: req.session.character
      email: req.session.email
    req.session.character = req.target._id.toString()
    req.session.email = req.target.email
    res.redirect '/game/dev'

  app.post '/dev/unpossess', developers_only, (req, res, next) ->
    return next('Not currently possessing anyone.') unless req.session.possessor?
    req.session.character = req.session.possessor.character
    req.session.email = req.session.possessor.email
    delete req.session.possessor
    res.redirect '/game/dev'

  app.post '/dev/materialize', developers_only, (req, res, next) ->
    return next('Invalid item.') unless req.body.item?.length
    commands.give.items req.character, null, {item: req.body.item, count: parseInt(req.body.quantity ? 1)}, (err) ->
      return next(err) if err?
      res.redirect '/game/dev'
