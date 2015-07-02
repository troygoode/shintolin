marked = require 'marked'

marked.setOptions
  gfm: true
  tables: true
  breaks: true
  sanitize: true
  smartypants: true

module.exports =
  port: process.env.PORT or 3000
  session_secret: process.env.SESSION_SECRET or 'secret'
  mongo_uri: process.env.MONGOLAB_URI or 'mongodb://localhost/shintolin'
  maximum_cpus: process.env.MAXIMUM_CPUS or 1

  maximum_level: 18
  default_terrain: 'wilderness'

  production: process.env.NODE_ENV is 'production'

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
