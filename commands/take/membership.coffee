module.exports.can = (character, tile, msg) ->
  throw 'You must belong to this settlement to do that.' if tile.settlement_id? and not (tile.settlement_id.toString() is character.settlement_id?.toString())
