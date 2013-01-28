_ = require 'underscore'
_str = require 'underscore.string'
async = require 'async'
db = require '../db'
queries = require '../queries'
data = require '../data'
radius = 5
hq_building = data.buildings.totem

module.exports = (founder, hq, name, cb) ->
  now = new Date()
  tiles = null
  settlement = null

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
      # get all tiles
      queries.tiles_in_circle_around hq, radius, (err, t) ->
        return cb(err) if err?
        tiles = t.map (tile) ->
          tile._id
        cb()
    , (cb) ->
      # insert settlement
      s =
        slug: _str.slugify name
        name: name
        motto: ''
        description: ''
        website_url: ''
        image_url: ''
        x: hq.x
        y: hq.y
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
      #TODO: create tiles that don't otherwise exist
      query =
        _id: {$in: tiles}
      update =
        $set:
          settlement_id: settlement._id
          settlement_name: settlement.name
          settlement_slug: settlement.slug
      db.tiles.update query, update, false, true, cb
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
