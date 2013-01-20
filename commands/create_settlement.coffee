_ = require 'underscore'
async = require 'async'
db = require '../db'
queries = require '../queries'
radius = 5

module.exports = (character, center, name, cb) ->
  now = new Date()
  tiles = null
  settlement = null

  async.series [
    (cb) ->
      # get all tiles
      queries.tiles_in_circle_around center, radius, (err, t) ->
        return cb(err) if err?
        tiles = t.map (tile) ->
          tile._id
        cb()
    , (cb) ->
      # insert settlement
      s =
        slug: _.str.slugify name
        name: name
        x: center.x
        y: center.y
        radius: radius
        founded: now
        leader_title: 'Leader'
        leader:
          _id: character._id
          name: characer.name
          slug: character.slug
        member_count: 1
        members: [
          {
            _id: character._id
            name: characer.name
            slug: character.slug
            voting_for:
              _id: character._id
              name: characer.name
              slug: character.slug
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
      # update character
      query =
        _id: character._id
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
