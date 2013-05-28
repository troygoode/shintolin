_ = require 'underscore'
async = require 'async'
commands = require '../../../commands'
data = require '../../../data'
mw = require '../middleware'
MAX_WEIGHT = 70

module.exports = (app) ->
  app.post '/give', mw.not_dazed, mw.available_actions(), (req, res, next) ->
    return next('Invalid Target') unless req.target?
    return next('Invalid Item') unless req.item?
    return next('That item may not be traded or dropped.') if req.item.nodrop or req.item.intrinsic

    quantity = parseInt(req.param('quantity'))
    inventory_item = _.find req.character.items, (i) ->
      i.item is req.item.id
    return next("You don\'t have #{quantity} #{req.item.name} to give away.") unless inventory_item.count >= quantity

    if req.target is 'building'
      return next('You cannot leave items in this building.') unless _.contains(req.actions, 'give')
    else
      weight = quantity * (req.item.weight ? 0)
      return next("Giving that to #{req.target.name} would overburden them.") if req.target.weight + weight > MAX_WEIGHT

    async.series [
      (cb) ->
        commands.remove_item req.character, req.item, quantity, cb
      (cb) ->
        if req.target is 'building'
          commands.add_item req.tile, req.item, quantity, cb
        else
          commands.add_item req.target, req.item, quantity, cb
      (cb) ->
        commands.charge_ap req.character, 1, cb
      (cb) ->
        if req.target is 'building'
          msg =
            item: req.item.id
            quantity: quantity
            building: req.tile.building
        else
          msg =
            item: req.item.id
            quantity: quantity
            target_id: req.target._id
            target_name: req.target.name
            target_slug: req.target.slug
        commands.send_message 'give', req.character, req.character, msg, cb
      (cb) ->
        return cb() if req.target is 'building'
        msg =
          item: req.item.id
          quantity: quantity
          target_id: req.target._id
          target_name: req.target.name
          target_slug: req.target.slug
        commands.send_message 'given', req.character, req.target, msg, cb
      (cb) ->
        if req.target is 'building'
          msg =
            item: req.item.id
            quantity: quantity
            building: req.tile.building
        else
          msg =
            item: req.item.id
            quantity: quantity
            target_id: req.target._id
            target_name: req.target.name
            target_slug: req.target.slug
        commands.send_message_nearby 'give_nearby', req.character, [req.character], msg, cb
    ], (err) ->
      return next(err) if err?
      res.redirect '/game'
