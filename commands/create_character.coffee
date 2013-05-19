_ = require 'underscore'
_str = require 'underscore.string'
async = require 'async'
bcrypt = require 'bcrypt'
db = require '../db'
queries = require '../queries'
create_tile = require './create_tile'
default_coords =
  x: 0
  y: 0

module.exports = (name, email, password, settlement, cb) ->
  now = new Date()
  hash = bcrypt.hashSync password, 12
  character =
    slug: _str.slugify name
    name: name
    email: email
    password: hash

    x: if settlement? then settlement.x else default_coords.x
    y: if settlement? then settlement.y else default_coords.y
    z: 0
    hp: 50
    hp_max: 50
    ap: 100.0
    recovery: 3.0
    hunger: 9
    last_action: now

    level: 1
    level_crafter: 0
    level_warrior: 0
    level_herbalist: 0
    level_wanderer: 0
    xp_crafter: 0
    xp_warrior: 0
    xp_herbalist: 0
    xp_wanderer: 0
    skills: []

    items: []
    weight: 0

    #donated: false #don't need to store
    #banned: false #don't need to store


    kills: 0
    frags: 1
    deaths: 0
    revives: 0
    created: now
    last_revived: now

    bio: ''
    image_url: ''
  if settlement?
    character.settlement_id  = settlement._id
    character.settlement_name = settlement.name
    character.settlement_slug = settlement.slug
    character.settlement_joined = now
    character.settlement_provisional = settlement.population is 0
  finish = (tile) ->
    async.parallel [
      (cb) ->
        db.characters.insert character, cb
      , (cb) ->
        query =
          _id: tile._id
        update =
          $push:
            people:
              _id: character._id
              slug: character.slug
              name: character.name
              hp: character.hp
              hp_max: character.hp_max
        if settlement?
          update.$push.people.settlement_id = settlement._id
        db.tiles.update query, update, cb
    ], (err, [character]) ->
      cb err, character
  queries.get_tile_by_coords character, (err, tile) ->
    return cb(err) if err?
    if tile?
      finish tile
    else
      create_tile character, 'wilderness', (err, tile) ->
        return cb(err) if err?
        finish tile
