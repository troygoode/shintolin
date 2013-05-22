queries = require '../queries'
send_message_all = require './send_message_all'

module.exports = (type, sender, coords, blacklist = [], message = {}, cb) ->
  queries.get_tile_by_coords coords, (err, tile) ->
    return cb(err) if err?
    return cb() unless tile?
    send_message_all type, sender, tile.people, blacklist ? [], message ? {}, cb
