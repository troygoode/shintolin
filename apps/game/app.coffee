_ = require 'underscore'
express = require 'express'
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
]

app = module.exports = express()
app.set 'views', "#{__dirname}/views"
app.set 'view engine', 'jade'

app.use express.favicon "#{__dirname}/public/favicon.ico"
app.use express.static "#{__dirname}/public"
app.use assets

app.use express.bodyParser()
app.use express.methodOverride()
app.use express.cookieParser()
app.use shared_session

app.use middleware.auth
app.use express.csrf()
app.use middleware.csrf
app.use middleware.load_character
app.use middleware.load_tile
app.use auto_loader for key, auto_loader of middleware.auto_loaders
app.use middleware.time
app.use middleware.expose_querystring

app.locals._ = _
app.locals.config = config
app.locals.data = data

app.use app.router
route app for key, route of routes

app.use (err, req, res, next) ->
  if typeof err is 'string'
    res.redirect '/game?error=' + err
  else
    next err
