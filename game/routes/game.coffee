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
    ], (err, [tiles, messages]) ->
      return next(err) if err?
      action_messages = messages.filter (msg) ->
        msg.type isnt 'social'
      chat_messages = messages.filter (msg) ->
        msg.type is 'social'
      res.render 'game/index',
        character: req.character
        tiles: tiles
        action_messages: action_messages
        chat_messages: chat_messages
