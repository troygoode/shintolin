_ = require 'underscore'
express = require 'express'
favicon = require 'express-favicon'
body_parser = require 'body-parser'
method_override = require 'method-override'
cookie_parser = require 'cookie-parser'
csurf = require 'csurf'
stylus = require 'connect-stylus'
config = require '../../config'
data = require '../../data'
shared_session = require '../shared_session'
middleware = require './middleware'
routes = require('require-directory')(module, "#{__dirname}/routes")

app = module.exports = express()
app.set 'views', "#{__dirname}/views"
app.set 'view engine', 'jade'
app.enable 'trust proxy'

app.locals._ = _
app.locals.config = config
app.locals.data = data

app.use middleware.debug.request

app.use favicon "#{__dirname}/../assets/public/favicon.ico"
app.get '/css/game.css', stylus
  entry: "#{__dirname}/../assets/stylus/game.styl"
app.get '/css/tiles.css', stylus
  entry: "#{__dirname}/../assets/stylus/tiles.styl"
app.use body_parser.urlencoded(extended: true)
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
app.use (req, res, next) ->
  res.locals.rounded = (num) ->
    Math.floor(num * 10) / 10
  next()

app.use middleware.debug 'shintolin:middleware', 'exit'

router = express.Router()
app.use router
route router for key, route of routes

app.use (err, req, res, next) ->
  if typeof err is 'string'
    res.redirect '/game?error=' + err
  else
    console.log err
    next err
