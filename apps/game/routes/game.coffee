_ = require 'underscore'
async = require 'async'
moment = require 'moment'
queries = require '../../../queries'
data = require '../../../data'

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
        if center.z is 0
          row.push
            x: x
            y: y
            z: center.z
            terrain: 'wilderness'
        else if center.z is 1
          row.push
            x: x
            y: y
            z: center.z
            terrain: 'nothing'
  rows

visit_tile = (tile, center, character) ->
  retval =
    tile: tile
    terrain: data.terrains[tile.terrain]
    building: data.buildings[tile.building] if tile.building?
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
    retval.cost = if retval.terrain.cost_to_enter? then retval.terrain.cost_to_enter tile, center, character else 1
  retval

visit_weapon = (weapon, character, tile) ->
  id: weapon.id
  name: weapon.name
  hit_chance: weapon.accuracy(character, null, tile)
  damage: weapon.damage(character, null, tile)

visit_usable = (item, character, tile) ->
  id: item.id
  name: item.name

visit_recipe = (recipe, character, tile) ->
  io = recipe.craft character, tile
  takes = io.takes
  items = []
  items.push {item: key, count: value} for key, value of takes.items
  id: recipe.id
  name: recipe.name
  ap: takes.ap
  items: items
  tools: takes.tools

visit_building = (building, character, tile) ->
  io = building.build character, tile
  takes = io.takes
  items = []
  items.push {item: key, count: value} for key, value of takes.items
  id: building.id
  name: building.name
  ap: takes.ap
  items: items
  tools: takes.tools

module.exports = (app) ->
  app.get '/', (req, res, next) ->
    res.locals.moment = moment
    res.locals.describe_list = describe_list
    async.parallel [
      (cb) ->
        queries.tiles_in_square_around req.character, 3, cb
      , (cb) ->
        queries.latest_chat_messages req.character, 0, 12, cb
      , (cb) ->
        if req.tile.building is 'totem'
          queries.get_settlement req.tile.settlement_id.toString(), cb
        else
          cb null, null
    ], (err, [tiles, messages, settlement]) ->
      return next(err) if err?
      center = get_center tiles, req.character
      weapons = []
      weapons = req.character.items.filter (i) ->
        type = data.items[i.item]
        i.count > 0 and type.tags? and type.tags.indexOf('weapon') isnt -1
      weapons = weapons.map (i) ->
        visit_weapon data.items[i.item], req.character, center
      weapons.unshift visit_weapon data.items.fist, req.character, center
      usables = req.character.items.filter (i) ->
        type = data.items[i.item]
        i.count > 0 and type.tags? and type.tags.indexOf('usable') isnt -1
      usables = usables.map (i) ->
        visit_usable data.items[i.item], req.character, center
      build_recipes = ->
        visit_recipe(recipe, req.character, center) for key, recipe of data.recipes
      build_buildings = ->
        visit_building(building, req.character, center) for key, building of data.buildings
      locals =
        character: req.character
        grid: build_grid tiles, req.character
        center: center
        messages: messages
        time: req.time
        data: data
        weapons: weapons
        usables: usables
        settlement: settlement
        recipes: build_recipes()
        buildings: build_buildings()
      for row, i in locals.grid
        for tile, j in row
          locals.grid[i][j] = visit_tile tile, locals.center, locals.character
      locals.center = visit_tile locals.center, undefined, locals.character
      locals.dbg =
        center: center
      res.render 'game/index', locals
