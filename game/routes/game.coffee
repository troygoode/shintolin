async = require 'async'
moment = require 'moment'
queries = require '../../queries'

module.exports = (app) ->
  app.get '/', (req, res, next) ->
    res.locals.moment = moment
    async.parallel [
      (cb) ->
        queries.tiles_in_square_around req.character.x, req.character.y, req.character.z, cb
      , (cb) ->
        queries.latest_chat_messages req.character, cb
    ], (err, [tiles, chat_messages]) ->
      return next(err) if err?
      res.render 'game/index',
        character: req.character
        tiles: tiles
        chat_messages: chat_messages
