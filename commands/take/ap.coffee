Bluebird = require 'bluebird'
charge_ap = Bluebird.promisify(require '../charge_ap')

module.exports.can = (character, tile, msg) ->
  throw 'Invalid AP Quantity' unless msg > 0
  throw 'Insufficient AP' unless character.ap >= msg

module.exports.take = (character, tile, msg) ->
  throw 'Invalid AP Quantity' unless msg > 0
  charge_ap character, msg
