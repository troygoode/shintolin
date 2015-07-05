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

    #TODO: find abandoned items
    # https://github.com/Buttercup2k/Shintolin/blob/master/functions.cgi#L2654

    commands.increment_search req.tile, (err) ->
      return next(err) if err?

      req.tile.searches ?= 0

      search_odds = terrain.search_odds(req.character, req.tile)
      for key, odds of search_odds
        item = data.items[key]
        if item.modify_search_odds?
          search_odds[key] = item.modify_search_odds odds

      queries.process_loot_table search_odds, (err, item_type, total_odds) ->
        return next(err) if err?
        if item_type?
          commands.give.items req.character, null, {item: item_type, count: 1}, (err) ->
            return next(err) if err?
            msg =
              item: item_type
            if _.contains req.character.skills, 'foraging'
              msg.total_odds = total_odds
            commands.send_message 'search', req.character, req.character, msg, (err) ->
              return next(err) if err?
              commands.give.xp req.character, req.tile, {wanderer: 1}, (err) ->
                return next(err) if err?
                return res.redirect '/game'
        else
          msg = {}
          if _.contains req.character.skills, 'foraging'
            msg.total_odds = total_odds
          commands.send_message 'search', req.character, req.character, msg, (err) ->
            return next(err) if err?
            return res.redirect '/game'
