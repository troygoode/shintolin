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
app.get '/css/game2.css', stylus
  entry: "#{__dirname}/../assets/stylus/apps/game.styl"
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
app.use middleware.time
app.use middleware.expose_querystring
app.use (req, res, next) ->
  res.locals.rounded = (num) ->
    Math.round(num * 10) / 10
  res.locals.with_commas = (num) ->
    nStr = (num ? '').toString()
    x = nStr.split('.')
    x1 = x[0]
    x2 = if x.length > 1 then ('.' + x[1]) else ''
    rgx = /(\d+)(\d{3})/
    while (rgx.test(x1))
      x1 = x1.replace(rgx, '$1' + ',' + '$2')
    return x1 + x2
  next()

app.use middleware.debug 'shintolin:middleware', 'exit'

router = express.Router()
app.use router
route router for key, route of routes

app.use (err, req, res, next) ->
  if err and err.message is 'CHARACTER_BANNED'
    return res.render 'banned', message: 'LOL U R BANNED'

  if typeof err is 'string'
    if req.body.origin is 'history'
      res.redirect '/game/chat?error=' + err
    else
      res.redirect '/game?error=' + err
  else
    console.log err
    next err
