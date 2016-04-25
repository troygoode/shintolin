_ = require 'underscore'
async = require 'async'
moment = require 'moment'
config = require '../../../config'
queries = require '../../../queries'
data = require '../../../data'
mw = require '../middleware'
MAX_WEIGHT = 70
MAX_HUNGER = 12

action_counts = (actions) ->
  retval = _.chain(actions)
    .groupBy('category')
    .mapObject((arr) -> arr.length)
    .value()
  retval

measure_weight = (weight) ->
  if weight is 0
    'None'
  else if weight <= 30
    'Light'
  else if weight <= 50
    'Medium'
  else if weight <= 60
    'Heavy'
  else if weight <= MAX_WEIGHT
    'Very Heavy'
  else
    'Encumbered'

get_center = (tiles, character) ->
  tile = _.find tiles, (t) -> t.x is character.x and t.y is character.y
  tile ?
    x: character.x
    y: character.y
    z: character.z
    terrain: config.default_terrain
    people: []

get_exterior = (tile, cb) ->
  return cb() unless tile? and tile.z isnt 0
  queries.get_tile_by_coords {x: tile.x, y: tile.y, z: 0}, cb

build_grid = (tiles, center) ->
  rows = []
  for y in [center.y - 2 .. center.y + 2]
    row = []
    rows.push row
    for x in [center.x - 2 .. center.x + 2]
      tile = _.find tiles, (t) -> t.x is x and t.y is y
      if tile?
        row.push tile
      else
        if center.z is 0
          row.push
            x: x
            y: y
            z: center.z
            terrain: config.default_terrain
        else if center.z is 1
          row.push
            x: x
            y: y
            z: center.z
            terrain: 'nothing'
  rows

resolve_terrain = (character, tile) ->
  building = data.buildings[tile.building] if tile?.building?
  terrain = if tile?.z is 0 and building?.exterior? then building.exterior else (tile?.terrain ? config.default_terrain)
  if _.isFunction terrain
    terrain = terrain character, tile
  data.terrains[terrain]

visit_tile = (tile, center, character, visible) ->
  building = data.buildings[tile.building] if tile?.building?
  terrain = resolve_terrain character, tile
  retval =
    tile: tile
    terrain: terrain
    style: if _.isFunction(terrain?.style) then terrain.style() else terrain?.style
    building: building
    people: tile.people?.filter (p) ->
      _.contains(visible, p._id.toString()) and
        not p.creature? and
        p._id.toString() isnt character._id.toString()
    creatures: tile.people?.filter (p) ->
      return false unless p.creature?
      if _.isString p.creature
        p.creature = data.creatures[p.creature]
      true
  retval.tile.items ?= []
  if center?
    if tile.x is center.x - 1 and tile.y is center.y - 1
      retval.direction = 'nw'
    else if tile.x is center.x and tile.y is center.y - 1
      retval.direction = 'n'
    else if tile.x is center.x + 1 and tile.y is center.y - 1
      retval.direction = 'ne'
    else if tile.x is center.x - 1 and tile.y is center.y
      retval.direction = 'w'
    else if tile.x is center.x + 1 and tile.y is center.y
      retval.direction = 'e'
    else if tile.x is center.x - 1 and tile.y is center.y + 1
      retval.direction = 'sw'
    else if tile.x is center.x and tile.y is center.y + 1
      retval.direction = 's'
    else if tile.x is center.x + 1 and tile.y is center.y + 1
      retval.direction = 'se'
    else if tile.x is center.x and tile.y is center.y and center.z is 0 and building?.interior?
      retval.direction = 'in'
    else if tile.x is center.x and tile.y is center.y and center.z is 1
      retval.direction = 'out'
    retval.cost = queries.cost_to_enter character, center, tile
  retval

module.exports = (app) ->
  app.get '/', mw.chat_locals, mw.available_actions(), (req, res, next) ->
    locals = {}
    res.locals.moment = moment

    async.parallel [
      (cb) ->
        queries.active_or_healthy_players (err, visible) ->
          if err?
            cb err
          else
            cb null, _.pluck(visible, '_id').map((id) -> id.toString())
      (cb) ->
        get_exterior req.tile, cb
      (cb) ->
        queries.tiles_in_square_around req.character, 3, cb
      (cb) ->
        queries.latest_chat_messages req.character, 0, 25, cb
      (cb) ->
        if req.tile?.building is 'totem'
          queries.get_settlement req.tile?.settlement_id.toString(), cb
        else
          cb null, null
      (cb) ->
        queries.calculate_recovery(req.character, req.tile)
          .then (recovery) ->
            cb null, recovery
          .catch (err) ->
            cb err
    ], (err, [visible, exterior, tiles, messages, settlement, recovery]) ->
      return next(err) if err?
      center = get_center tiles, req.character
      building = if req.tile?.building? then data.buildings[req.tile.building] else null
      terrain = resolve_terrain req.character, req.tile
      locals =
        _nav: 'game'
        character: req.character
        grid: build_grid tiles, req.character
        center: center
        building: building
        terrain: terrain
        messages: messages
        time: req.time
        data: data
        settlement: settlement
        encumberance: measure_weight req.character.weight
        hunger_debuff: queries.calculate_hunger_debuff req.character, req.tile
        recovery: recovery
        exterior: exterior
        action_counts: action_counts(req.actions)
        max_weight: MAX_WEIGHT

      for row, i in locals.grid
        for tile, j in row
          locals.grid[i][j] = visit_tile tile, locals.center, locals.character, visible
      locals.center = visit_tile locals.center, undefined, locals.character, visible

      res.render 'game/index', locals
