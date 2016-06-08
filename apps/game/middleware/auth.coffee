_ = require 'underscore'
Bluebird = require 'bluebird'
get_character = Bluebird.promisify(require '../../../queries/get_character')
get_tile_by_coords = Bluebird.promisify(require '../../../queries/get_tile_by_coords')
active_or_healthy_players = Bluebird.promisify(require '../../../queries/active_or_healthy_players')

module.exports = (req, res, next) ->
  return res.redirect '/?msg=auth' unless req.session?.character?.length
  res.locals.is_developer = req.session?.developer is true

  Bluebird.resolve()
    .then ->
      get_character req.session.character

    .tap (character) ->
      if character.banned is true
        throw new Error('CHARACTER_BANNED')

    .then (character) ->
      return unless character?
      req.character = character
      res.locals.character = character
      get_tile_by_coords x: character.x, y: character.y, z: character.z

    .then (tile) ->
      return unless tile?

      # remove inactive people
      active_or_healthy_players()
        .then (active) ->
          active = _.pluck(active ? [], '_id').map((id) -> id.toString())
          tile.people = tile.people.filter (p) ->
            p.creature? or _.contains(active, p._id.toString())
          req.tile = tile
          res.locals.tile = tile

    .then ->
      if req.character?
        next()
      else
        res.redirect('/logout') #probably a db reset
    .catch next
