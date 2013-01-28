queries = require '../queries'
send_message_all = require './send_message_all'

module.exports = (type, sender, blacklist, message, cb) ->
  queries.get_tile_by_coords sender, (err, tile) ->
    return cb(err) if err?
    send_message_all type, sender, tile.people, blacklist, message, cb
