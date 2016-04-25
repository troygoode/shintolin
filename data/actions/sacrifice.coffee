Bluebird = require 'bluebird'
db = require '../../db'
craft = Bluebird.promisify(require '../../commands/craft')
{buildings, items} = require '../'
send_message_settlement = Bluebird.promisify(require '../../commands/send_message_settlement')
remove_item = Bluebird.promisify(require '../../commands/remove_item')

module.exports = (character, tile) ->
  return false unless character.settlement_id?
  return false if character.settlement_provisional
  return false unless character.settlement_id?.toString() is tile.settlement_id?.toString()

  building = buildings[tile.building]

  category: 'building'
  ap: 1
  accepts: building.sacrifice.accepts

  execute: (body) ->
    item = items[body.item]
    sacrifice = building.sacrifice.accepts[body.item]

    Bluebird.resolve()
      .then ->
        throw new Error('INVALID SACRIFICE') unless sacrifice?
        remove_item character, item, sacrifice.count

      .then ->
        db.settlements().findOne {_id: tile.settlement_id}

      .tap (settlement) ->
        msg =
          settlement_id: settlement._id
          settlement_name: settlement.name
          settlement_slug: settlement.slug
          item: body.item
          count: sacrifice.count
          favor: sacrifice.favor
        send_message_settlement 'sacrifice', character, settlement, [], msg

      .tap (settlement) ->
        QUERY = {_id: settlement._id}
        UPDATE = $inc: {favor: sacrifice.favor}
        db.settlements().updateOne QUERY, UPDATE
