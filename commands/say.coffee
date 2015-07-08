async = require 'async'
db = require '../db'
queries = require '../queries'
send_message = require './send_message'
send_message_coords = require './send_message_coords'
send_message_nearby = require './send_message_nearby'
SHOUT_RADIUS = 75

module.exports = (character, target, text, volume, cb) ->
  msg =
    text: text
  if target?
    msg.target_id = target._id
    msg.target_name = target.name
    msg.target_slug = target.slug
  if volume?.length
    msg.volume = volume

  switch volume
    when 'whisper'
      if target?
        async.parallel [
          (cb) ->
            send_message 'social', character, character, msg, cb
          (cb) ->
            send_message 'social', character, target, msg, cb
        ], cb
      else
        send_message_nearby 'social', character, null, msg, cb
    when 'shout'
      char_coords = x: character.x, y: character.y

      in_radius = queries.coords_in_circle_around char_coords, SHOUT_RADIUS
      in_radius = in_radius.map (tile) ->
        x: tile.x
        y: tile.y
        z: 0
      for tile in in_radius
        in_radius.push x: tile.x, y: tile.y, z: 1

      async.eachSeries in_radius, (tile, cb) ->
        send_message_coords 'social', character, tile, null, msg, cb
      , cb
    else
      send_message_nearby 'social', character, null, msg, cb
