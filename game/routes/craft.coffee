_ = require 'underscore'
async = require 'async'
mw = require '../middleware'
data = require '../../data'
commands = require '../../commands'

module.exports = (app) ->
  app.post '/craft', mw.not_dazed, (req, res, next) ->
    recipe = data.recipes[req.param('recipe')]
    return next('Invalid recipe') unless recipe?

    takes = recipe.takes req.character
    gives = recipe.gives req.character
    return next('Insufficient AP') unless req.character.ap >= takes.ap

    broken = []

    if takes.tools?
      for tool in takes.tools
        unless _.some(req.character.items, (i) -> i.item is tool)
          return next("You must have a #{tool} to craft that.")
        else
          tool_type = data.items[tool]
          broken.push tool if tool_type.break_odds? and Math.random() <= tool_type.break_odds

    items_to_take = []
    items_to_take.push item: key, count: value for key, value of takes.items

    items_to_give = []
    items_to_give.push item: key, count: value for key, value of gives.items

    for item in items_to_take
      item_in_inventory = _.find req.character.items, (i) ->
        i.item is item.item
      return next("You don't have enough #{item.item} to craft that.") unless item_in_inventory?.count >= item.count

    async.series [
      (cb) ->
        # take items from inventory
        take_item = (item, cb) ->
          commands.remove_item req.character, data.items[item.item], item.count, cb
        async.forEach items_to_take, take_item, cb
      , (cb) ->
        # charge ap
        commands.charge_ap req.character, takes.ap, cb
      , (cb) ->
        # give new items to inventory
        give_item = (item, cb) ->
          commands.add_item req.character, data.items[item.item], item.count, cb
        async.forEach items_to_give, give_item, cb
      , (cb) ->
        # remove broken tools from inventory
        return cb() unless broken.length
        break_item = (item, cb) ->
          commands.remove_item req.character, data.items[break_item], 1, cb
        async.forEach broken, break_item, cb
      , (cb) ->
        # grant xp
        commands.xp req.character, gives.xp.wanderer ? 0, gives.xp.herbalist ? 0, gives.xp.crafter ? 0, gives.xp.warrior ? 0, cb
      , (cb) ->
        # notify user of success
        commands.send_message 'craft', req.character, req.character,
          recipe: recipe.name
          received: items_to_give
          broken: broken
        , cb
    ], (err) ->
      return next(err) if err?
      res.redirect '/game'
