module.exports = (app) ->

  app.get '/faq', (req, res) ->
    res.render 'faq'

