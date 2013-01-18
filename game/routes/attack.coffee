_ = require 'underscore'
async = require 'async'
commands = require '../../commands'
data = require '../../data'
mw = require '../middleware'

module.exports = (app) ->
  app.post '/attack', mw.not_dazed, mw.ap(1), (req, res, next) ->
    return next('Invalid target.') unless req.target?
    return next('Invalid weapon.') unless req.item? and _.contains req.item.tags, 'weapon'
    return next('Your target is already knocked out.') if req.target.hp <= 1
    #TODO: validate that user has the weapon in inventory and that it is a weapon
    commands.attack req.character, req.target, req.tile, req.item, (err) ->
      return next(err) if err?
      res.redirect '/game'
