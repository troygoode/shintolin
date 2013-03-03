async = require 'async'
queries = require '../../../queries'
data = require '../../../data'

map_tile = (tile) ->
  x: tile.x
  y: tile.y
  z: tile.z
  terrain: tile.terrain

map_terrain = (terrain) ->
  id: terrain.id
  style: terrain.style

map_settlement = (settlement) ->
  _id: settlement.settlement._id.toString()
  name: settlement.settlement.name
  tiles: settlement.tiles.map(map_tile)

module.exports = (app) ->

  app.get '/map', (req, res) ->
    res.render 'map'

  app.get '/api/map', (req, res, next) ->
    queries.all_tiles 0, (err, tiles) ->
      return next(err) if err?
      res.json tiles.map(map_tile)

  app.get '/api/map/terrains', (req, res) ->
    terrains = []
    terrains.push(map_terrain(terrain)) for key, terrain of data.terrains
    res.json terrains

  app.get '/api/map/settlements', (req, res) ->
    queries.all_settlements (err, settlements) ->
      async.map settlements, (settlement, cb) ->
        queries.tiles_in_settlement settlement, (err, tiles) ->
          return cb(err) if err?
          cb null, settlement: settlement, tiles: tiles
      , (err, settlements) ->
        res.json settlements.map(map_settlement)
