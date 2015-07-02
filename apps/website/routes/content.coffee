module.exports = (app) ->

  app.get '/credits', (req, res) ->
    res.render 'credits'

  app.get '/faq', (req, res) ->
    res.render 'faq'

  app.get '/screenshot', (req, res) ->
    res.render 'screenshot'

