_ = require 'underscore'
async = require 'async'
commands = require '../../commands'
data = require '../../data'
mw = require '../middleware'

module.exports = (app) ->
  app.post '/attack', mw.not_dazed, mw.ap(1), (req, res, next) ->
    return next('Invalid target.') unless req.target?
    return next('Invalid weapon.') unless req.item? and _.contains req.item.tags, 'weapon'
    if req.target is 'building'
      return next('There is no building to attack.') unless req.tile.building?
      return next('You cannot attack a building from within it.') unless req.character.z is 0
      #TODO: validate that no other buildings are around IF THIS IS A TOTEM
      commands.demolish req.character, req.tile, req.item, (err) ->
        return next(err) if err?
        res.redirect '/game'
    else
      return next('Your target is already knocked out.') if req.target.hp <= 1
      commands.attack req.character, req.target, req.tile, req.item, (err) ->
        return next(err) if err?
        res.redirect '/game'
