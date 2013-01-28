queries = require '../queries'
send_message_tile = require './send_message_tile'

module.exports = (type, sender, blacklist, message, cb) ->
  queries.get_tile_by_coords sender, (err, tile) ->
    return cb(err) if err?
    send_message_tile type, sender, tile, blacklist, message, cb
