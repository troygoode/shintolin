module.exports.can = (character, tile, msg) ->
  return unless tile.settlement_id?
  return if (tile.settlement_id.toString() is character.settlement_id?.toString()) and not character.settlement_provisional
  throw 'You must belong to this settlement to do that.'
