_ = require 'underscore'
async = require 'async'
moment = require 'moment'
queries = require '../../queries'
data =
  terrains: require '../../data/terrains'

center = (tiles, character) ->
  tile = _.find tiles, (t) -> t.x is character.x and t.y is character.y
  if tile?
    tile
  else
    x: character.x
    y: character.y
    z: character.z
    terrain: 'wilderness'

grid = (tiles, center) ->
  rows = []
  for y in [center.y - 2 .. center.y + 2]
    row = []
    rows.push row
    for x in [center.x - 2 .. center.x + 2]
      tile = _.find tiles, (t) -> t.x is x and t.y is y
      if tile?
        row.push tile
      else
        row.push
          x: x
          y: y
          z: center.z
          terrain: 'wilderness'
  rows

visit_tile = (tile, center, character) ->
  retval =
    tile: tile
    terrain: data.terrains[tile.terrain]
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
    retval.cost = retval.terrain.cost_to_enter tile, center, character
  retval

module.exports = (app) ->
  app.get '/', (req, res, next) ->
    res.locals.moment = moment
    async.parallel [
      (cb) ->
        queries.tiles_in_square_around req.character, cb
      , (cb) ->
        queries.latest_chat_messages req.character, cb
    ], (err, [tiles, messages]) ->
      return next(err) if err?
      action_messages = messages.filter (msg) ->
        msg.type isnt 'social'
      chat_messages = messages.filter (msg) ->
        msg.type is 'social'
      locals =
        character: req.character
        grid: grid tiles, req.character
        center: center tiles, req.character
        action_messages: action_messages
        chat_messages: chat_messages
        time: req.time
        data: data
      for row, i in locals.grid
        for tile, j in row
          locals.grid[i][j] = visit_tile tile, locals.center, locals.character
      locals.center = visit_tile locals.center, undefined, locals.character
      res.render 'game/index', locals
