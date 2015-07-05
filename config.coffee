marked = require 'marked'

marked.setOptions
  gfm: true
  tables: true
  breaks: true
  sanitize: true
  smartypants: true

module.exports =
  port: process.env.PORT or 3000
  session_secret: process.env.SESSION_SECRET ? 'secret'
  mongo_uri: process.env.MONGODB_URI ? process.env.MONGOLAB_URI ? 'mongodb://localhost/shintolin'
  web_concurrency: process.env.WEB_CONCURRENCY ? 1

  maximum_level: 18
  default_terrain: 'wilderness'

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
      when 'SUMMER'
        new Date(2013, 0, 12)
      when 'WINTER'
        new Date(2013, 0, 15)
      else
        new Date()
