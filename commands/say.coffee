async = require 'async'
db = require '../db'
queries = require '../queries'
charge_ap = require './charge_ap'
send_message = require './send_message'
send_message_all = require './send_message_all'
send_message_coords = require './send_message_coords'
send_message_nearby = require './send_message_nearby'

whisper = (character, target, msg, cb) ->
  if target?
    async.parallel [
      (cb) ->
        send_message 'social', character, character, msg, cb
      (cb) ->
        send_message 'social', character, target, msg, cb
    ], cb
  else
    send_message_nearby 'social', character, null, msg, cb

ooc = (character, target, msg, cb) ->
  queries.all_active_players (err, players) ->
    return cb(err) if err?
    send_message_all 'social', character, players, [], msg, cb

shout = (character, target, msg, cb) ->
  SHOUT_RADIUS = 15
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

say = (character, target, msg, cb) ->
  send_message_nearby 'social', character, null, msg, cb

module.exports = (character, target, text = '', volume, cb) ->
  text = text.trim()
  return cb() unless text.length

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
      async.series [
        (cb) ->
          charge_ap character, 0, cb
        (cb) ->
          whisper character, target, msg, cb
      ], cb
    when 'shout'
      async.series [
        (cb) ->
          charge_ap character, 0, cb
        (cb) ->
          shout character, target, msg, cb
      ], cb
    when 'ooc'
      async.series [
        (cb) ->
          charge_ap character, 0, cb
        (cb) ->
          ooc character, target, msg, cb
      ], cb
    when '', 'emote'
      async.series [
        (cb) ->
          charge_ap character, 0, cb
        (cb) ->
          say character, target, msg, cb
      ], cb
    else
      cb 'Unknown Chat Volume'
