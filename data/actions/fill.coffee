_ = require 'underscore'
Bluebird = require 'bluebird'
{items} = require '../'
craft = Bluebird.promisify(require('../../commands').craft)
send_message = Bluebird.promisify(require('../../commands').send_message)

module.exports = (character, tile) ->
  category: 'location'
  ap: 1

  execute: ->
    Bluebird.resolve()
      .then ->
        craft character, tile,
          takes:
            items:
              pot: 1
          gives:
            items:
              pot_water: 1
            xp:
              wanderer: 1
        , null

      .then (recipe) ->
        send_message 'fill', character, character, null
