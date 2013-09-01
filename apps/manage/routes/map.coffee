#TODO allow map manipulation from this view
#TODO allow importing maps safely (only overwrite wilderness; only overwrite no-regions with specificed regions)

_ = require 'underscore'
async = require 'async'
queries = require '../../../queries'
data = require '../../../data'

map_tile = (tile) ->
  x: tile.x
  y: tile.y
  z: tile.z
  terrain: tile.terrain
  settlement_id: tile.settlement_id?.toString()
  region: tile.region

map_terrain = (terrain) ->
  id: terrain.id
  style: if _.isFunction(terrain.style) then terrain.style() else terrain.style

map_region = (region) ->
  id: region.id
  name: region.name

map_settlement = (settlement) ->
  _id: settlement._id.toString()
  name: settlement.name

map_tile_tsv = (tile) ->
  [
    tile.x
    tile.y
    tile.region ? 'no-region'
    tile.terrain
  ].join('\t')

filter_all = (tile) ->
  tile.terrain isnt 'wilderness' or
    tile.settlement_id? or
    tile.building?

filter_tsv = (tile) ->
  tile.terrain isnt 'wilderness'

module.exports = (app) ->

  app.get '/map', (req, res) ->
    res.render 'map'

  app.get '/api/map', (req, res, next) ->
    queries.all_tiles 0, (err, tiles) ->
      return next(err) if err?
      res.json tiles.filter(filter_all).map(map_tile)

  app.get '/api/map/metadata', (req, res, next) ->
    async.parallel [
      (cb) ->
        terrains = []
        terrains.push(map_terrain(terrain)) for key, terrain of data.terrains
        cb null, terrains
      (cb) ->
        regions = []
        regions.push(map_region(region)) for key, region of data.regions
        cb null, regions
      (cb) ->
        queries.all_settlements (err, settlements) ->
          return cb(err) if err?
          cb null, settlements.map(map_settlement)
    ], (err, [terrains, regions, settlements]) ->
      return next(err) if err?
      res.json
        terrains: terrains
        regions: regions
        settlements: settlements

  app.get '/api/map.tsv', (req, res, next) ->
    queries.all_tiles 0, (err, tiles) ->
      return next(err) if err?
      res.set 'Content-Type', 'text/plain'
      res.set 'Content-disposition', 'attachment; filename=shintolin.tsv'
      rows = tiles.filter(filter_tsv).map(map_tile_tsv)
      res.send 'X\tY\tRegion\tTerrain\n' + rows.join('\n')
