express = require 'express'
config = require '../../config'
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

app.use express.urlencoded()
app.use express.json()
app.use express.methodOverride()
app.use express.cookieParser()
app.use shared_session

app.use (req, res, next) ->
  req.time = time()
  res.locals.time = req.time
  next()

app.use (req, res, next) ->
  res.locals.logged_in = req.session.character?
  next()

app.use app.router
app.use(express.errorHandler(
  dumpExceptions: config.production
  showStack: config.production
))

route app for key, route of routes
