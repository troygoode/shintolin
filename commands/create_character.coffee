_ = require 'underscore'
_str = require 'underscore.string'
async = require 'async'
bcrypt = require 'bcrypt'
db = require '../db'
queries = require '../queries'
teleport = require './teleport'
default_coords =
  x: 0
  y: 0
  z: 0

module.exports = (name, email, password, settlement, cb) ->
  now = new Date()
  slug = _str.slugify name
  coords = default_coords

  if settlement?
    coords =
      x: settlement.x
      y: settlement.y
      z: 0

  create_character = (cb) ->
    hash = bcrypt.hashSync password, 12
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
      character.settlement_provisional = settlement.population isnt 0
      character.settlement_joined = now
    db.characters.insert character, cb

  async.waterfall [
    (cb) ->
      create_character cb
    (character, cb) ->
      teleport character, undefined, coords, cb
    (ignore, cb) ->
      queries.get_character_by_slug slug, cb
  ], cb
