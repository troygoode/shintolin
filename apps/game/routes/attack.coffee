_ = require 'underscore'
async = require 'async'
commands = require '../../../commands'
queries = require '../../../queries'
data = require '../../../data'
mw = require '../middleware'

big_buildings = []
for key, b of data.buildings
  if b.interior?
    big_buildings.push b.id

buildings_to_destroy_first = (req, cb) ->
  return cb(null, 0) unless req.tile.hq
  queries.tiles_in_circle_around req.tile, 5, (err, tiles) ->
    return cb(err) if err?
    matching = tiles.filter (t) ->
      return false unless t.building?
      return false if t.hq
      big_buildings.indexOf(t.building) isnt -1
    cb null, matching.length

module.exports = (app) ->
  app.post '/attack', mw.not_dazed, mw.ap(1), (req, res, next) ->
    return next('Invalid target.') unless req.target?
    return next('Invalid weapon.') unless req.item? and _.contains req.item.tags, 'weapon'
    if req.target is 'building'
      return next('There is no building to attack.') unless req.tile.building?
      return next('You cannot attack a building from within it.') unless req.character.z is 0
      buildings_to_destroy_first req, (err, number) ->
        return next(err) if err?
        return next("There are still #{number} large buildings in the vicinity. You must destroy all the buildings in the area before you can attack the #{req.tile.building}.") if number > 0
        commands.damage_building req.character, req.tile, req.item, (err) ->
          return next(err) if err?
          res.redirect '/game'
    else
      return next('Your target is already knocked out.') if req.target.hp <= 1
      commands.attack req.character, req.target, req.tile, req.item, (err) ->
        return next(err) if err?
        res.redirect '/game'
