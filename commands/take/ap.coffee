Bluebird = require 'bluebird'
charge_ap = Bluebird.promisify(require '../charge_ap')

module.exports.can = (character, tile, msg) ->
  throw 'Insufficient AP' unless character.ap >= msg

module.exports.take = (character, tile, msg) ->
  charge_ap character, msg
