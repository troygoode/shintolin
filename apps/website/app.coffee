express = require 'express'
favicon = require 'express-favicon'
errorhandler = require 'errorhandler'
body_parser = require 'body-parser'
cookie_parser = require 'cookie-parser'
method_override = require 'method-override'
csurf = require 'csurf'
stylus = require 'connect-stylus'
config = require '../../config'
time = require '../../time'
shared_session = require '../shared_session'
game_app = require '../game/app'
management_app = require '../manage/app'
queries = require '../../queries'
routes = require('require-directory')(module, "#{__dirname}/routes")

app = module.exports = express()
app.set 'views', "#{__dirname}/views"
app.set 'view engine', 'jade'

app.use '/game', game_app
app.use '/manage', management_app
app.use favicon "#{__dirname}/../assets/public/favicon.ico"
app.get '/css/default.css', stylus
  entry: "#{__dirname}/../assets/stylus/default.styl"
app.get '/css/apps/website.css', stylus
  entry: "#{__dirname}/../assets/stylus/apps/website.styl"
app.use express.static "#{__dirname}/../assets/public"

app.use body_parser.urlencoded(extended: true)
app.use body_parser.json()
app.use method_override()
app.use cookie_parser()
app.use shared_session

app.use csurf()
app.use (req, res, next) ->
  res.locals.csrf = req.csrfToken()
  next()

app.use (req, res, next) ->
  req.time = time()
  res.locals.time = req.time
  next()

app.use (req, res, next) ->
  res.locals.logged_in = req.session.character?
  return next() unless res.locals.logged_in
  queries.get_character req.session.character, (err, character) ->
    return next(err) if err?
    res.locals.is_developer = req.session.developer
    res.locals.current_character = character
    next()

router = express.Router()
app.use router
route router for key, route of routes

app.use(errorhandler(
  dumpExceptions: config.production
  showStack: config.production
))

app.listen config.port, ->
  console.log "apps/website/app listening on port #{config.port}"
