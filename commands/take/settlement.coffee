module.exports.can = (character, tile, msg) ->
  throw 'You must do this within a settlement.' if not tile.settlement_id?
