_ = require 'underscore'
express = require 'express'
assets = require 'connect-assets'
config = require '../../config'
data = require '../../data'
shared_session = require '../shared_session'
middleware = require './middleware'
routes = require('require-directory')(module, "#{__dirname}/routes")

app = module.exports = express()
app.set 'views', "#{__dirname}/views"
app.set 'view engine', 'jade'

app.use express.favicon("#{__dirname}/public/favicon.ico")
app.use express.static "#{__dirname}/public"
app.use assets
  src: "#{__dirname}/assets"
  helperContext: app.locals
  servePath: '/game'

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

app.locals._ = _
app.locals.data = data

app.use app.router
route app for key, route of routes
