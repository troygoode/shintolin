_ = require 'underscore'
express = require 'express'
favicon = require 'express-favicon'
body_parser = require 'body-parser'
method_override = require 'method-override'
cookie_parser = require 'cookie-parser'
csurf = require 'csurf'
rack = require 'asset-rack'
config = require '../../config'
data = require '../../data'
shared_session = require '../shared_session'
middleware = require './middleware'
routes = require('require-directory')(module, "#{__dirname}/routes")

assets = new rack.Rack [
  new rack.StylusAsset
    url: '/css/game.css'
    filename: "#{__dirname}/assets/css/game.styl"
    compress: config.production
  new rack.StylusAsset
    url: '/css/tiles.css'
    filename: "#{__dirname}/assets/css/tiles.styl"
    compress: config.production
  new rack.SnocketsAsset
    url: '/js/game.js'
    filename: "#{__dirname}/assets/js/game.coffee"
    compress: config.production
  new rack.SnocketsAsset
    url: '/js/persist-selections.js'
    filename: "#{__dirname}/assets/js/persist_selections.coffee"
    compress: config.production
]

app = module.exports = express()
app.set 'views', "#{__dirname}/views"
app.set 'view engine', 'jade'
app.enable 'trust proxy'

app.locals._ = _
app.locals.config = config
app.locals.data = data

app.use middleware.debug.request

app.use favicon "#{__dirname}/../website/public/favicon.ico"
app.use express.static "#{__dirname}/public"
# app.use assets
app.use body_parser.urlencoded()
app.use body_parser.json()
app.use method_override()
app.use cookie_parser()
app.use shared_session

app.use middleware.debug 'shintolin:middleware', (req) ->
  "enter (#{req.url})"

app.use middleware.auth
app.use middleware.track_hits

app.use csurf()
app.use middleware.csrf
app.use middleware.debug 'shintolin:middleware', 'autoloaders enter'
app.use middleware.load_character
app.use middleware.load_tile
app.use auto_loader for key, auto_loader of middleware.auto_loaders
app.use middleware.debug 'shintolin:middleware', 'autoloaders exit'
app.use middleware.time
app.use middleware.expose_querystring

app.use middleware.debug 'shintolin:middleware', 'exit'

router = express.Router()
app.use router
route router for key, route of routes

app.use (err, req, res, next) ->
  if typeof err is 'string'
    res.redirect '/game?error=' + err
  else
    next err
