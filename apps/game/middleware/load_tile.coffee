queries = require '../../../queries'

module.exports = (req, res, next) ->
  return next() unless req.character?
  queries.get_tile_by_coords req.character, (err, tile) ->
    return next(err) if err?
    req.tile = tile
    next()
