_ = require 'underscore'
async = require 'async'
data = require '../../../data'
mw = require '../middleware'
commands = require '../../../commands'
queries = require '../../../queries'
settlement_radius = 10
minimum_huts = 3
hut_radius = 2
settlement_name_format = /^\w+(\s\w+)*$/

module.exports = (app) ->

  app.get '/settle', mw.not_dazed, (req, res, next) ->
    async.parallel [
      (cb) ->
        queries.buildings_in_radius req.tile, settlement_radius, data.buildings.totem, cb
      (cb) ->
        queries.buildings_in_radius req.tile, hut_radius, data.buildings.hut, cb
      (cb) ->
        queries.distance_to_closest_totem req.tile, settlement_radius, cb
    ], (err, [totems, huts, distances]) ->
      return next(err) if err?
      res.render 'settle',
        settlements: totems
        settlement_radius: settlement_radius
        settlement_distances: distances
        huts: huts
        hut_radius: hut_radius
        minimum_huts: minimum_huts

  app.post '/settle', mw.not_dazed, (req, res, next) ->
    async.parallel [
      (cb) ->
        queries.buildings_in_radius req.tile, settlement_radius, data.buildings.totem, cb
      , (cb) ->
        queries.buildings_in_radius req.tile, hut_radius, data.buildings.hut, cb
    ], (err, [totems, huts]) ->
      return next(err) if err?
      return next('You must provide a name for your new settlement.') unless req.body.name?.length
      return next('Settlement name not long enough.') unless req.body.name.length >= 2
      return next('Settlement name too long.') unless req.body.name.length <= 32
      return next('You must leave your current settlement before starting a new one.') if req.character.settlement_id?
      return next('There are settlements too close.') if totems > 0
      return next('There are not enough huts nearby.') if huts < minimum_huts
      return next('There is already a building here.') if req.tile.building?
      return next('Invalid settlement name.') unless settlement_name_format.test req.body.name

      building = data.buildings.totem

      takes = building.build(req.character, req.tile).takes
      return next('Insufficient AP') unless req.character.ap >= takes.ap

      if takes.tools?
        for tool in takes.tools
          unless _.some(req.character.items, (i) -> i.item is tool)
            return next("You must have a #{tool} to build that.")

      terrain = data.terrains[req.tile.terrain]
      return next('Nothing can be built here.') unless terrain.buildable?
      return next('You cannot build that here.') unless terrain.buildable.indexOf(building.size) isnt -1

      items_to_take = []
      items_to_take.push item: key, count: value for key, value of takes.items

      settlement = null
      async.series [
        (cb) ->
          # validate settlement name uniqueness
          queries.all_settlements (err, settlements) ->
            return cb(err) if err?
            return cb('Settlement name already in use.') if _.some(settlements, (s) ->
              s.name.toLowerCase() is req.body.name.toLowerCase())
            cb()
        , (cb) ->
          # take items from inventory
          take_item = (item, cb) ->
            commands.remove_item req.character, data.items[item.item], item.count, cb
          async.forEach items_to_take, take_item, cb
        , (cb) ->
          # charge ap
          commands.charge_ap req.character, takes.ap, cb
        , (cb) ->
          # create settlement
          commands.create_settlement req.character, req.tile, req.body.name, (err, s) ->
            return cb(err) if err?
            settlement = s
            cb()
        , (cb) ->
          # notify user of success
          commands.send_message 'settled', req.character, req.character,
            settlement_id: settlement._id
            name: settlement.name
            slug: settlement.slug
          , cb
        , (cb) ->
          # notify others of success
          commands.broadcast_message 'settled_nearby', req.character, [req.character],
            settlement_id: settlement._id
            name: settlement.name
            slug: settlement.slug
          , cb
      ], (err) ->
        return next(err) if err?
        res.redirect '/game'
