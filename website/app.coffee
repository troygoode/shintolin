express = require 'express'
game = require '../game/app'

app = module.exports = express()
app.set 'views', "#{__dirname}/views"
app.set 'view engine', 'jade'

app.use '/game', game

app.get '/', (req, res) ->
  res.send 'Hello World'

unless module.parent?
  app.listen 3000, ->
    console.log "SHINTOLIN (WEBSITE) listening on port 3000"
