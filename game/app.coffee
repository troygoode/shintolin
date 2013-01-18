express = require 'express'
assets = require 'connect-assets'
MongoSession = require('connect-mongo')(express)
config = require '../config'
middleware = require './middleware'
routes = require('require-directory')(module, "#{__dirname}/routes")

debug = process.env.NODE_ENV isnt 'production'

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
app.use express.session
  secret: config.session_secret
  store: new MongoSession(url: config.mongo_uri)

app.use middleware.auth
app.use middleware.load_character
app.use middleware.load_tile
app.use auto_loader for key, auto_loader of middleware.auto_loaders
app.use middleware.time

app.use app.router
app.use express.errorHandler
  dumpExceptions: debug
  showStack: debug

route app for key, route of routes

unless module.parent?
  app.listen config.port, ->
    console.log "SHINTOLIN (GAME) listening on port #{config.port}"
