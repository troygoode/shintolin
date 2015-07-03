_ = require 'underscore'
_str = require 'underscore.string'
async = require 'async'
db = require '../db'
queries = require '../queries'
teleport = require './teleport'
hash_password = require './hash_password'
join_settlement = require './join_settlement'

module.exports = (name, email, password, settlement, cb) ->
  now = new Date()
  slug = _str.slugify name
  character = null
  coords = null

  if settlement?
    coords =
      x: settlement.x
      y: settlement.y
      z: 0

  create_character = (coords, cb) ->
    hash = hash_password password
    character =
      slug: slug
      name: name
      email: email
      password: hash

      x: coords.x
      y: coords.y
      z: coords.z

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
      character.settlement_provisional = settlement.population isnt 0
    db.characters.insert character, cb

  async.series [
    (cb) ->
      return cb() if coords?
      queries.get_random_spawnable_tile (err, tile) ->
        return cb(err) if err?
        coords = tile
        cb()
    (cb) ->
      create_character coords, (err, _character) ->
        return cb(err) if err?
        character = _character
        cb()
    (cb) ->
      teleport character, undefined, coords, cb
    (cb) ->
      return cb() unless settlement?
      join_settlement character, settlement, cb
    (cb) ->
      queries.get_character_by_slug slug, cb
  ], (err) ->
    return cb(err) if err?
    cb null, character
