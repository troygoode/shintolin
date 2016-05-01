Bluebird = require 'bluebird'
craft = require '../../commands/craft'
{buildings} = require '../'
send_message_settlement = Bluebird.promisify(require '../../commands/send_message_settlement')

AP_COST = 1

module.exports = (character, tile) ->
  return false unless character.settlement_id?
  return false if character.settlement_provisional
  return false unless character.settlement_id?.toString() is tile.settlement_id?.toString()

  building = buildings[tile.building]

  category: 'building'
  ap: AP_COST
  charge_ap: false # will do via recipe
  accepts: building.sacrifice.accepts

  execute: (body) ->
    sacrifice = building.sacrifice.accepts[body.item]

    Bluebird.resolve()
      .then ->
        throw new Error('INVALID SACRIFICE') unless sacrifice?
        recipe =
          takes:
            ap: AP_COST
            items: {}
          gives: {}
        recipe.takes.items[body.item] = sacrifice.count
        recipe.gives.favor = sacrifice.favor
        craft character, tile, recipe

      .then ->
        msg =
          item: body.item
          count: sacrifice.count
          favor: sacrifice.favor
        send_message_settlement 'sacrifice', character, tile.settlement_id, [], msg
