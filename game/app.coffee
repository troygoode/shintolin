express = require 'express'

app = module.exports = express()
app.set 'views', "#{__dirname}/views"
app.set 'view engine', 'jade'

app.get '/', (req, res) ->
  res.send 'Hello World (Game)'

unless module.parent?
  app.listen 3000, ->
    console.log "SHINTOLIN (GAME) listening on port 3000"
