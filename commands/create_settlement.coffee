_ = require 'underscore'
_str = require 'underscore.string'
async = require 'async'
db = require '../db'
queries = require '../queries'
data = require '../data'
create_tile = require './create_tile'
radius = 5
hq_building = data.buildings.totem

db.register_index db.tiles,
  x: 1
  y: 1
  z: 1

module.exports = (founder, hq, name, cb) ->
  now = new Date()
  coords = null
  settlement = null

  return cb('Cannot create settlements in the wilderness.') unless hq.region?

  async.series [
    (cb) ->
      # update hq tile
      query =
        x: hq.x
        y: hq.y
        z: 0
      update =
        $set:
          building: hq_building.id
          hp: hq_building.hp
          hq: true
      db.tiles.update query, update, cb
    , (cb) ->
      # get all coords
      coords = queries.coords_in_circle_around hq, radius
      cb()
    , (cb) ->
      # insert settlement
      s =
        slug: _str.slugify name
        name: name
        motto: ''
        open: false
        description: ''
        website_url: ''
        image_url: ''
        x: hq.x
        y: hq.y
        region: hq.region
        radius: radius
        founded: now
        founder:
          _id: founder._id
          name: founder.name
          slug: founder.slug
        leader_title: 'Leader'
        leader:
          _id: founder._id
          name: founder.name
          slug: founder.slug
        population: 1
        members: [
          {
            _id: founder._id
            name: founder.name
            slug: founder.slug
            joined: now
            voting_for:
              _id: founder._id
              name: founder.name
              slug: founder.slug
          }
        ]
      db.settlements.insert s, (err, s) ->
        return cb(err) if err?
        settlement = s
        cb()
    , (cb) ->
      # update all tiles
      coords_and_inside = coords.concat coords.map((c) ->
        x: c.x
        y: c.y
        z: 1
      )
      update_tile = (tile, cb) ->
        query =
          _id: tile._id
        update =
          $set:
            settlement_id: settlement._id
            settlement_name: settlement.name
            settlement_slug: settlement.slug
        db.tiles.update query, update, cb
      async.each coords_and_inside, (coord, cb) ->
        queries.get_tile_by_coords coord, (err, tile) ->
          return cb(err) if err?
          return update_tile(tile, cb) if tile?
          return cb() unless coord.z is 0 # don't create underground tiles automatically
          create_tile coord, undefined, undefined, (err, tile) ->
            return cb(err) if err?
            update_tile tile, cb
      , cb
    , (cb) ->
      # update founder
      query =
        _id: founder._id
      update =
        $set:
          settlement_id: settlement._id
          settlement_name: settlement.name
          settlement_slug: settlement.slug
          settlement_joined: now
      db.characters.update query, update, cb
  ], (err) ->
    return cb(err) if err?
    cb null, settlement
