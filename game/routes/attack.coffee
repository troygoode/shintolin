async = require 'async'
commands = require '../../commands'
queries = require '../../queries'
data = require '../../data'

module.exports = (app) ->
  app.post '/attack', (req, res, next) ->
    return res.redirect '/game' unless req.param('target')?.length
    async.parallel [
      (cb) ->
        queries.get_tile_by_coords req.character, cb
      , (cb) ->
        queries.get_character req.param('target'), (err, target) ->
          return cb(err) if err?
          return cb('invalid target') unless target?
          cb err, target
      , (cb) ->
        cb null, data.items[req.param('item')]
    ], (err, [tile, target, weapon]) ->
      commands.attack req.character, target, tile, weapon, (err) ->
        return next(err) if err?
        res.redirect '/game'
