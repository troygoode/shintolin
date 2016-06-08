Bluebird = require 'bluebird'
remove_item = Bluebird.promisify(require './remove_item')
take_handlers = require './take/index'
calculate_broken = require '../queries/calculate_broken'
items = (require '../data').items

module.exports = (character, tile, takes = {}, cb) ->
  Bluebird.resolve()

    # can
    .then ->
      Object.keys(takes)
    .each (key) ->
      handler = take_handlers[key]?.can
      if handler?
        handler character, tile, takes[key]

    # take
    .then ->
      Object.keys(takes)
    .each (key) ->
      handler = take_handlers[key]?.take
      if handler?
        handler character, tile, takes[key]

    # broken tools
    .then ->
      calculate_broken(takes.tools ? [])
    .tap (broken) ->
      Bluebird.resolve(broken)
        .each (tool) ->
          remove_item character, items[tool], 1

    # return
    .then (broken) ->
      cb null, broken
    .catch (err) ->
      if typeof err is 'string'
        cb(message: err)
      else
        cb err
