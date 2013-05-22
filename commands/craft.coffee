async = require 'async'
data = require '../data'
give = require './give'
take = require './take'

module.exports = (character, tile, craft_function, cb) ->
  result = craft_function character, tile
  return cb() unless result?

  async.waterfall [
    (cb) ->
      return cb() unless result.takes?
      take character, tile, result.takes, cb
    (broken_items, cb) ->
      return cb() unless result.gives?
      give character, tile, result.gives, (err) ->
        cb err, broken_items
  ], (err, broken_items) ->
    cb err, result, broken_items
