_ = require 'underscore'
mw = require '../middleware'
data = require '../../../data'
commands = require '../../../commands'

weighted_table = (table) ->
  result = {}
  total = 0
  for key, odds of table ? {}
    total += odds
    result[key] = total
  result

get_item = (table) ->
  r = Math.random()
  for item_type, odds of table ? {}
    return item_type if r < odds
  return null

total_odds = (table) ->
  odds = []
  odds.push o for key, o of table ? {}
  if odds.length
    _.max odds
  else
    0

module.exports = (app) ->
  app.post '/search', mw.not_dazed, mw.ap(1), (req, res, next) ->
    terrain = data.terrains[req.tile.terrain]
    unless terrain.search_odds?
      return commands.send_message 'search', req.character, req.character,
        unsearchable: true
      , (err) ->
        return next(err) if err?
        res.redirect '/game'

    commands.increment_search req.tile, (err) ->
      return next(err) if err?

      req.tile.searches ?= 0

      search_odds = terrain.search_odds req.tile, req.character
      weighted = weighted_table search_odds
      total = total_odds weighted
      return next('Total odds over 100%!') if total > 1
      item_type = get_item weighted

      if item_type?.length
        item = data.items[item_type]
        commands.add_item req.character, item, 1, (err) ->
          return next(err) if err?
          commands.send_message 'search', req.character, req.character,
            total_odds: total
            item: item_type
          , (err) ->
            return next(err) if err?
            commands.xp req.character, 1, 0, 0, 0, (err) ->
              return next(err) if err?
              return res.redirect '/game'
      else
        commands.send_message 'search', req.character, req.character,
          total_odds: total
        , (err) ->
          return next(err) if err?
          return res.redirect '/game'
