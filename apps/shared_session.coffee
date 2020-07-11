session = require 'express-session'
MongoStore = require('connect-mongo')(session)
config = require '../config'
db = require '../db'

module.exports = session
  key: 'shintolin.com'
  secret: config.session_secret
  store: new MongoStore(
    url: config.mongo_uri
    clientPromise: db.connect2().then((d) -> d.client)
    dbName: db.dbName()
  )
  saveUninitialized: false
  resave: false
  auto_reconnect: true
