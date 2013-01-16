_ = require 'underscore'
async = require 'async'
moment = require 'moment'
queries = require '../../queries'
data = require '../../data'

character_link = (character) ->
  "<a href='/profile/#{character._id}'>#{character.name}</a>"

describe_list = (arr) ->
  if arr.length is 1
    arr[0]
  else if arr.length is 2
    "#{arr[0]} and #{arr[1]}"
  else
    retval = ''
    for o, i in arr
      if i is arr.length - 1
        retval += "and #{o}"
      else
        retval += "#{o}, "
    retval

get_center = (tiles, character) ->
  tile = _.find tiles, (t) -> t.x is character.x and t.y is character.y
  if tile?
    tile
  else
    x: character.x
    y: character.y
    z: character.z
    terrain: 'wilderness'

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
    people: tile.people?.filter (p) ->
      p._id.toString() isnt character._id.toString()
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

visit_weapon = (weapon, character, tile) ->
  id: weapon.id
  name: weapon.name
  hit_chance: weapon.accuracy(character, null, tile)
  damage: weapon.damage(character, null, tile)

module.exports = (app) ->
  app.get '/', (req, res, next) ->
    res.locals.moment = moment
    res.locals.describe_list = describe_list
    res.locals.character_link = character_link
    async.parallel [
      (cb) ->
        queries.tiles_in_square_around req.character, 3, cb
      , (cb) ->
        queries.latest_chat_messages req.character, cb
    ], (err, [tiles, messages]) ->
      return next(err) if err?
      center = get_center tiles, req.character
      action_messages = messages.filter (msg) ->
        msg.type isnt 'social'
      chat_messages = messages.filter (msg) ->
        msg.type is 'social'
      items = []
      items.push item for key, item of data.items
      weapons = items.filter (i) ->
        i.tags.indexOf('weapon') isnt -1
      weapons = weapons.map (i) ->
        visit_weapon i, req.character, center
      locals =
        character: req.character
        grid: build_grid tiles, req.character
        center: center
        action_messages: action_messages
        chat_messages: chat_messages
        time: req.time
        data: data
        weapons: weapons
      for row, i in locals.grid
        for tile, j in row
          locals.grid[i][j] = visit_tile tile, locals.center, locals.character
      locals.center = visit_tile locals.center, undefined, locals.character
      res.render 'game/index', locals
