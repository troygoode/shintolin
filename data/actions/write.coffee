_ = require 'underscore'
Bluebird = require 'bluebird'
{items} = require '../'
write = Bluebird.promisify(require('../../commands').write)
send_message = Bluebird.promisify(require('../../commands').send_message)
send_message_nearby = Bluebird.promisify(require('../../commands').send_message_nearby)

module.exports = (character, tile) ->
  item = _.find character.items ? [], (item) ->
    type = items[item.item]
    item.count >= 1 and _.contains type.tags ? [], 'write'
  return false unless item?

  category: 'location'
  ap: 3
  message: tile.message

  execute: ({message}) ->
    Bluebird.resolve()
      .then ->
        write character, tile, message

      .then ->
        Bluebird.all [
          send_message 'write', character, character,
            message: message
            building: tile.building
            outside: tile.z is 0
          send_message_nearby 'write_nearby', character, [character],
            message: message
            building: tile.building
            outside: tile.z is 0
        ]
