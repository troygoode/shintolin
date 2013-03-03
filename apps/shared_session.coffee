express = require 'express'
MongoSession = require('connect-mongo')(express)
config = require '../config'

module.exports = express.session
  secret: config.session_secret
  store: new MongoSession(url: config.mongo_uri)
  auto_reconnect: true
