_ = require 'underscore'
async = require 'async'
commands = require '../../../commands'
mw = require '../middleware'

module.exports = (app) ->
  app.post '/use', mw.not_dazed, mw.ap(1), (req, res, next) ->
    return next('Invalid target.') unless req.target?
    return next('Invalid item.') unless req.item? and _.contains req.item.tags, 'usable'
    async.each req.item.tags, (tag, cb) ->
      handler = commands.use[tag]
      if handler?
        handler req.character, req.target, req.item, req.tile, cb
      else
        cb()
    , (err) ->
      return next(err) if err?
      if req.item.use?
        req.item.use req.character, req.target, req.item, req.tile, (err) ->
          return next(err) if err?
          res.redirect '/game'
      else
        res.redirect '/game'
