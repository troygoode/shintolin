config = require '../../config'
require('nodefly').profile(config.nodefly, ['Shintolin', 'Heroku']) if config.nodefly?.length

express = require 'express'
time = require '../../time'
shared_session = require '../shared_session'
game_app = require '../game/app'
management_app = require '../manage/app'
routes = require('require-directory')(module, "#{__dirname}/routes")

app = module.exports = express()
app.set 'views', "#{__dirname}/views"
app.set 'view engine', 'jade'

app.use '/game', game_app
app.use '/manage', management_app
app.use express.favicon "#{__dirname}/public/favicon.ico"
app.use express.static "#{__dirname}/public"

app.use express.bodyParser()
app.use express.methodOverride()
app.use express.cookieParser()
app.use shared_session

app.use (req, res, next) ->
  req.time = time(new Date())
  res.locals.time = req.time
  next()

app.use (req, res, next) ->
  res.locals.logged_in = req.session.character?
  next()

app.use app.router
app.use express.errorHandler
  dumpExceptions: config.production
  showStack: config.production

route app for key, route of routes

unless module.parent?
  app.listen config.port, ->
    console.log "SHINTOLIN (WEBSITE) listening on port #{config.port}"
