async = require 'async'
bcrypt = require 'bcrypt'
db = require '../db'
queries = require '../queries'
create_tile = require './create_tile'

module.exports = (name, email, password, settlement, cb) ->
  now = new Date()
  hash = bcrypt.hashSync password, 12
  character =
    name: name
    email: email
    password: hash

    x: settlement.x
    y: settlement.y
    z: 0
    hp: 50
    hp_max: 50
    ap: 100.0
    hunger: 9
    last_action: now

    xp_craft: 0
    xp_warrior: 0
    xp_herbal: 0
    xp_wanderer: 0
    skills: []
    items: []

    #donated: false #don't need to store
    #banned: false #don't need to store

    settlement: settlement._id
    settlement_joined: now

    kills: 0
    frags: 1
    deaths: 0
    revives: 0
    created: now
    last_revived: now

    bio: ''
    image_url: ''
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
              name: character.name
              hp: character.hp
              hp_max: character.hp_max
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
