_ = require 'underscore'
async = require 'async'
data = require '../data'
give = require './give'
take = require './take'

###

EXAMPLE RECIPE:

{
  takes: {
    ap: 10,
    tile_hp: 7,
    building: 'cottage',
    settlement: true,
    skill: 'construction',
    tools: ['stone'],
    items: {
      flint: 1
    }
  },
  gives: {
    items: {
      axe_hand: 1
    },
    xp: {
      crafter: 10
    },
    favor: 5,
    tile_hp: 7,
    terrain: 'woodland'
  }
}

###

module.exports = (character, tile, craft_obj, craft_function, cb) ->
  if _.isFunction(craft_function)
    result = craft_obj
    cb = craft_function
  else if craft_function?
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
