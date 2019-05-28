marked = require 'marked'

if process.env.NODE_ENV isnt 'production'
  require('dotenv').config(silent: true)

marked.setOptions
  gfm: true
  tables: true
  breaks: true
  sanitize: true
  smartypants: true

module.exports =
  port: process.env.PORT or 3000
  session_secret: process.env.SESSION_SECRET ? 'secret'
  mongo_uri: process.env.MONGODB_URI ? process.env.MONGOLAB_URI ? process.env.DATABASE_URL ? 'mongodb://localhost/heroku_8xb5fctf'
  web_concurrency: process.env.WEB_CONCURRENCY ? 1

  ap_per_hour: 3.0
  maximum_level: 18
  default_terrain: 'sea_deep'

  production: process.env.NODE_ENV is 'production'

  starting_items: [
    {
      item: 'noobcake'
      count: 9
    }
  ]

  now: ->
    switch process.env.FORCE_SEASON
      when 'SPRING'
        new Date(2013, 0, 6)
      when 'SUMMER'
        new Date(2013, 0, 9)
      when 'AUTUMN'
        new Date(2013, 0, 12)
      when 'WINTER'
        new Date(2013, 0, 15)
      else
        new Date()
