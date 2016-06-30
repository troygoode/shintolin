marked = require 'marked'
glob = require 'glob'
fs = require 'fs'

module.exports = (app) ->

  app.get '/discord', (req, res) ->
    res.render 'discord'

  app.get '/faq', (req, res) ->
    res.render 'faq'

  app.get '/sotg/2015-07-17', (req, res) ->
    file_content = fs.readFileSync "#{__dirname}/../../../data/sotg/2015-07-17.md", 'utf-8'
    res.render 'sotg',
      html: marked(file_content)

