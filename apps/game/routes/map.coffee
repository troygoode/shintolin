_ = require 'underscore'
queries = require '../../../queries'
data = require '../../../data'
config = require '../../../config'

build_grid = (tiles, center) ->
  rows = []
  for y in [center.y - 4 .. center.y + 4]
    row = []
    rows.push row
    for x in [center.x - 4 .. center.x + 4]
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

get_center = (tiles, character) ->
  tile = _.find tiles, (t) -> t.x is character.x and t.y is character.y
  tile ?
    x: character.x
    y: character.y
    z: character.z
    terrain: config.default_terrain
    people: []

visit_tile = (tile, center, character) ->
  terrain = data.terrains[tile.terrain]
  building = null

  if tile.building?
    building = data.buildings[tile.building]
    if building.exterior? and _.isFunction(building.exterior)
      terrain = data.terrains[building.exterior(character, tile)]
    else if building.exterior
      terrain = data.terrains[building.exterior]

  retval =
    tile: tile
    building: building
    terrain: terrain
    style: if _.isFunction(terrain.style) then terrain.style() else terrain.style

  if _.contains character.skills, 'tracking'
    retval = _.extend retval,
      people: tile.people?.filter (p) ->
        not p.creature? and p._id.toString() isnt character._id.toString()
      creatures: tile.people?.filter (p) ->
        return false unless p.creature?
        if _.isString p.creature
          p.creature = data.creatures[p.creature]
        true
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
  app.get '/map', (req, res, next) ->
    queries.tiles_in_square_around req.character, 5, (err, tiles) ->
      return next(err) if err?
      locals =
        _nav: 'map'
        grid: build_grid tiles, req.character
        time: req.time
        data: data
      locals.center = visit_tile get_center(tiles, req.character), undefined, req.character
      for row, i in locals.grid
        for tile, j in row
          locals.grid[i][j] = visit_tile tile, locals.center.tile, req.character
      res.render 'map', locals
