async = require 'async'
queries = require '../../queries'

module.exports = (app) ->
  app.get '/', (req, res, next) ->
    async.waterfall [
      (cb) ->
        queries.get_character req.session.character, (err, character) ->
          cb(err) if err?
          cb('NO_CHARACTER_FOUND') unless character?
          cb null, character
      , (character, cb) ->
        async.parallel [
          (cb) ->
            queries.tiles_in_square_around character.x, character.y, character.z, cb
          , (cb) ->
            queries.latest_chat_messages character, cb
        ], (err, [tiles, chat_messages]) ->
          cb err, character, tiles, chat_messages
    ], (err, character, tiles, chat_messages) ->
      if err is 'NO_CHARACTER_FOUND'
        res.redirect '/logout'
      else if err?
        next(err)
      else
        res.render 'game',
          character: character
          tiles: tiles
          chat_messages: chat_messages
