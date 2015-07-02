_ = require 'underscore'
express = require 'express'
body_parser = require 'body-parser'
method_override = require 'method-override'
cookie_parser = require 'cookie-parser'
csurf = require 'csurf'
favicon = require 'express-favicon'
config = require '../../config'
shared_session = require '../shared_session'
middleware = require './middleware'
routes = require('require-directory')(module, "#{__dirname}/routes")

app = module.exports = express()

app.set 'views', "#{__dirname}/views"
app.set 'view engine', 'jade'

app.locals._ = _
app.locals.config = config

app.use favicon "#{__dirname}/../website/public/favicon.ico"
app.use express.static "#{__dirname}/public"

app.use body_parser.urlencoded()
app.use body_parser.json()
app.use method_override()
app.use cookie_parser()
app.use shared_session

app.use middleware.auth
app.use csurf()
app.use middleware.csrf

router = express.Router()
app.use router
route router for key, route of routes

app.use (err, req, res, next) ->
  if _.isNumber err
    res.send err
  else
    next err
