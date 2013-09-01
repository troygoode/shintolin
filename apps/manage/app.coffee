_ = require 'underscore'
express = require 'express'
config = require '../../config'
shared_session = require '../shared_session'
middleware = require './middleware'
routes = require('require-directory')(module, "#{__dirname}/routes")

app = module.exports = express()

app.set 'views', "#{__dirname}/views"
app.set 'view engine', 'jade'

app.locals._ = _

app.use express.favicon "#{__dirname}/public/favicon.ico"
app.use express.static "#{__dirname}/public"

app.use express.bodyParser()
app.use express.methodOverride()
app.use express.cookieParser()
app.use shared_session

app.use middleware.auth
app.use express.csrf()

app.use app.router
route app for key, route of routes

app.use (err, req, res, next) ->
  if _.isNumber err
    res.send err
  else
    next err
