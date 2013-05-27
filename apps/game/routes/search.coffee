_ = require 'underscore'
mw = require '../middleware'
data = require '../../../data'
commands = require '../../../commands'
queries = require '../../../queries'

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
      queries.process_loot_table search_odds, (err, item_type, total_odds) ->
        return next(err) if err?
        if item_type?
          item = data.items[item_type]
          commands.add_item req.character, item, 1, (err) ->
            return next(err) if err?
            commands.send_message 'search', req.character, req.character,
              total_odds: total_odds
              item: item_type
            , (err) ->
              return next(err) if err?
              commands.xp req.character, 1, 0, 0, 0, (err) ->
                return next(err) if err?
                return res.redirect '/game'
        else
          commands.send_message 'search', req.character, req.character,
            total_odds: total_odds
          , (err) ->
            return next(err) if err?
            return res.redirect '/game'
