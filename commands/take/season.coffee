_ = require 'underscore'
time = require '../../time'

module.exports.can = (character, tile, msg) ->
  season = time().season.toLowerCase()
  seasons = if _.isArray(msg) then msg else [msg]
  throw "You must wait until #{seasons.join(' or ')} before you can do that." unless seasons.indexOf(season) isnt -1
