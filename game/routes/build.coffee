async = require 'async'
db = require '../../db'
commands = require '../../commands'
data = require '../../data'
mw = require '../middleware'

module.exports = (app) ->
  app.post '/build', mw.not_dazed, (req, res, next) ->
    building = data.buildings[req.param('building')]
    return next('Invalid Building') unless building?

    return next('There is already a building here.') if req.tile.building?

    takes = building.takes req.character, req.tile
    gives = building.gives req.character, req.tile
    return next('Insufficient AP') unless req.character.ap >= takes.ap

    terrain = data.terrains[req.tile.terrain]
    return next('Nothing can be built here.') unless terrain.buildable?
    return next('You cannot build that here.') unless terrain.buildable.indexOf(building.size) isnt -1

    items_to_take = []
    items_to_take.push item: key, count: value for key, value of takes.items

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
        # update current tile
        query =
          _id: req.tile._id
        update =
          $set:
            building: building.id
            hp: building.hp
        db.tiles.update query, update, cb
      , (cb) ->
        # create interior tile
        # TODO: should the interior tile know what kind of building it is?
        return cb() unless building.interior?
        coords =
          x: req.tile.x
          y: req.tile.y
          z: 1
        commands.create_tile coords, building.interior, cb
      , (cb) ->
        # grant xp
        commands.xp req.character, gives.xp.wanderer ? 0, gives.xp.herbalist ? 0, gives.xp.crafter ? 0, gives.xp.warrior ? 0, cb
      , (cb) ->
        # notify user of success
        # TODO: notify others?
        commands.send_message 'built', req.character, req.character,
          building: building.id
        , cb
    ], (err) ->
      return next(err) if err?
      res.redirect '/game'
