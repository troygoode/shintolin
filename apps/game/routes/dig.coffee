async = require 'async'
_ = require 'underscore'
commands = require '../../../commands'
queries = require '../../../queries'
data = require '../../../data'
mw = require '../middleware'

module.exports = (app) ->
  app.post '/dig', mw.not_dazed, mw.available_actions('dig'), (req, res, next) ->
    terrain = data.terrains[req.tile.terrain]
    return next('This terrain does not support digging.') unless terrain.dig_odds?

    loot_table = terrain.dig_odds req.character, req.tile
    queries.process_loot_table loot_table, (err, found_item_type, total_odds) ->
      return next(err) if err?

      recipe =
        takes:
          ap: 2
          tools: ['digging_stick']
      if found_item_type?
        recipe.gives =
          items: {}
          xp:
            wanderer: 1
        recipe.gives.items[found_item_type] = 1

      commands.craft req.character, req.tile, recipe, null, (err, recipe, broken_items) ->
        return next(err) if err?
        msg =
          found: found_item_type
          broken: broken_items?.length > 0
          broken_item: broken_items[0]
        commands.send_message 'dig', req.character, req.character, msg, (err) ->
          return next(err) if err?
          res.redirect '/game'
