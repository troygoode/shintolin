_ = require 'underscore'
async = require 'async'
data = require '../data'
give = require './give'
take = require './take'

module.exports = (character, tile, craft_obj, craft_function, cb) ->
  if craft_function?
    result = craft_obj[craft_function](character, tile)
  else if _.isFunction craft_obj
    result = craft_obj(character, tile)
  else
    result = craft_obj
  return cb('No crafting requirements or results specified.') unless result?

  async.waterfall [
    (cb) ->
      return cb() unless result.validate?
      result.validate cb
    (cb) ->
      return cb() unless result.takes?
      take character, tile, result.takes, cb
    (broken_items, cb) ->
      return cb(null, broken_items) unless result.gives?
      async.each _.keys(result.gives), (key, cb) ->
        handler = give[key]
        if handler?
          handler character, tile, result.gives[key], cb
        else
          cb()
      , (err) ->
        cb err, broken_items
  ], (err, broken_items) ->
    cb err, result, broken_items
