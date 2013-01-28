queries = require '../queries'
send_message_all = require './send_message_all'

get_tile = (coords, cb) ->
  return cb(null, coords) if coords._id?
  queries.get_tile_by_coords
    x: coords.x
    y: coords.y
    z: coords.z
  , cb

module.exports = (type, sender, coords, blacklist = [], message = {}, cb) ->
  get_tile coords, (err, tile) ->
    return cb(err) if err?
    send_message_all type, sender, tile.people, blacklist, message, cb
