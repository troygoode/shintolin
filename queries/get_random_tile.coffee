config = require '../config'
db = require '../db'

db.register_index db.tiles,
  terrain: 1
  z: 1

query =
  z: 0
  terrain:
    $ne: config.default_terrain

module.exports = (cb) ->
  db.tiles.find(query).count (err, count) ->
    return cb(err) if err?
    random = Math.floor(Math.random() * count)
    db.tiles.find(query).limit(-1).skip(random).toArray (err, tiles) ->
      return cb(err) if err?
      return cb() unless tiles?.length
      cb null, tiles[0]
