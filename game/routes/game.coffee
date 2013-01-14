_ = require 'underscore'
async = require 'async'
moment = require 'moment'
queries = require '../../queries'
data =
  terrains: require '../../data/terrains'

center = (tiles, character) ->
  tile = _.find tiles, (t) -> t.x is character.x and t.y is character.y
  if tile?
    tile: tile
    terrain: data.terrains[tile.terrain]
  else
    tile:
      x: character.x
      y: character.y
      z: character.z
    terrain:
      style: 'wilderness'

grid = (tiles, center) ->
  rows = []
  for y in [center.y - 2 .. center.y + 2]
    row = []
    rows.push row
    for x in [center.x - 2 .. center.x + 2]
      tile = _.find tiles, (t) -> t.x is x and t.y is y
      if tile?
        row.push
          tile: tile
          terrain: data.terrains[tile.terrain]
      else
        row.push
          tile:
            x: x
            y: y
            z: center.z
          terrain:
            style: 'wilderness'
  rows

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
      res.render 'game/index', locals
